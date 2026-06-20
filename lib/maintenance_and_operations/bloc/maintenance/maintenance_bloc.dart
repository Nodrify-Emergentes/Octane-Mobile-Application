import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octane_mobile/maintenance_and_operations/bloc/maintenance/maintenance_event.dart';
import 'package:octane_mobile/maintenance_and_operations/bloc/maintenance/maintenance_state.dart';
import 'package:octane_mobile/maintenance_and_operations/services/maintenance_service.dart';
import 'package:octane_mobile/vehicle_management/services/vehicle_service.dart';
import 'package:octane_mobile/iam/services/user_service.dart';
import 'package:octane_mobile/maintenance_and_operations/model/maintenance_card.dart';
import 'package:octane_mobile/maintenance_and_operations/model/maintenance.dart' as maintenance_model;

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final MaintenanceService maintenanceService;
  final VehicleService vehicleService;
  final UserService userService;

  MaintenanceBloc({
    required this.maintenanceService,
    required this.vehicleService,
    required this.userService,
  }) : super(MaintenanceInitial()) {
    on<FetchMaintenanceByIdEvent>(_onFetchMaintenanceById);
    on<FetchMaintenancesByMechanicIdEvent>(_onFetchMaintenancesByMechanicId);
    on<FetchMaintenancesByVehicleIdEvent>(_onFetchMaintenancesByVehicleId);
    on<FetchMaintenancesByOwnerIdEvent>(_onFetchMaintenancesByOwnerId);
    on<CreateMaintenanceEvent>(_onCreateMaintenance);
    on<DeleteMaintenanceEvent>(_onDeleteMaintenance);
    on<UpdateMaintenanceStatusEvent>(_onUpdateMaintenanceStatus);
    on<AssignExpenseToMaintenanceEvent>(_onAssignExpenseToMaintenance);
  }

  Future<void> _onFetchMaintenanceById(
    FetchMaintenanceByIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.getMaintenanceById(event.maintenanceId);
      emit(MaintenanceLoaded(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenance: $e'));
    }
  }

  Future<void> _onFetchMaintenancesByMechanicId(
    FetchMaintenancesByMechanicIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenances = await maintenanceService.getMaintenancesByMechanicId(event.mechanicId);
      emit(MaintenancesLoaded(maintenances));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenances by mechanic: $e'));
    }
  }

  Future<void> _onFetchMaintenancesByVehicleId(
    FetchMaintenancesByVehicleIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenances = await maintenanceService.getMaintenancesByVehicleId(event.vehicleId);
      emit(MaintenancesLoaded(maintenances));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenances by vehicle: $e'));
    }
  }

  Future<void> _onFetchMaintenancesByOwnerId(
    FetchMaintenancesByOwnerIdEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      // 1. Get all vehicles for the owner
      final vehicles = await vehicleService.getVehiclesByOwnerId(event.ownerId);

      if (vehicles.isEmpty) {
        emit(MaintenanceCardsLoaded(
          scheduledMaintenances: [],
          completedMaintenances: [],
        ));
        return;
      }

      // 2. Get maintenances for all vehicles
      final List<MaintenanceCard> allCards = [];

      for (final vehicle in vehicles) {
        try {
          final maintenances = await maintenanceService.getMaintenancesByVehicleId(vehicle.id);

          // 3. Create cards and load additional data
          for (final maintenance in maintenances) {
            final card = MaintenanceCard(maintenance: maintenance);

            // Load vehicle and mechanic data
            try {
              final mechanic = await userService.getUserById(maintenance.mechanicId);
              allCards.add(card.copyWith(
                vehicle: vehicle,
                mechanic: mechanic,
              ));
            } catch (e) {
              // Add card with vehicle but without mechanic if mechanic fetch fails
              allCards.add(card.copyWith(vehicle: vehicle));
            }
          }
        } catch (e) {
          print('Error loading maintenances for vehicle ${vehicle.id}: $e');
          // Continue with other vehicles even if one fails
        }
      }

      // 4. Separate into scheduled and completed
      final scheduled = allCards.where((card) =>
        card.maintenance.state == maintenance_model.MaintenanceState.pending ||
        card.maintenance.state == maintenance_model.MaintenanceState.inProgress
      ).toList();

      final completed = allCards.where((card) =>
        card.maintenance.state == maintenance_model.MaintenanceState.completed ||
        card.maintenance.state == maintenance_model.MaintenanceState.cancelled
      ).toList();

      emit(MaintenanceCardsLoaded(
        scheduledMaintenances: scheduled,
        completedMaintenances: completed,
      ));
    } catch (e) {
      emit(MaintenanceError('Failed to fetch maintenances by owner: $e'));
    }
  }

  Future<void> _onCreateMaintenance(
    CreateMaintenanceEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.createMaintenance(event.maintenanceData);
      emit(MaintenanceCreated(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to create maintenance: $e'));
    }
  }

  Future<void> _onDeleteMaintenance(
    DeleteMaintenanceEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      await maintenanceService.deleteMaintenance(event.maintenanceId);
      emit(MaintenanceDeleted());
    } catch (e) {
      emit(MaintenanceError('Failed to delete maintenance: $e'));
    }
  }

  Future<void> _onUpdateMaintenanceStatus(
    UpdateMaintenanceStatusEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.updateMaintenanceStatus(
        event.maintenanceId,
        event.newStatus,
      );
      emit(MaintenanceStatusUpdated(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to update maintenance status: $e'));
    }
  }

  Future<void> _onAssignExpenseToMaintenance(
    AssignExpenseToMaintenanceEvent event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceLoading());
    try {
      final maintenance = await maintenanceService.assignExpenseToMaintenance(
        event.maintenanceId,
        event.expenseId,
      );
      emit(MaintenanceExpenseAssigned(maintenance));
    } catch (e) {
      emit(MaintenanceError('Failed to assign expense to maintenance: $e'));
    }
  }
}

