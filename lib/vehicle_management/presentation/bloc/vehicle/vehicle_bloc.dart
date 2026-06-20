import 'package:bloc/bloc.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:octane_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_state.dart';
import 'package:octane_mobile/vehicle_management/services/model_service.dart';
import 'package:octane_mobile/vehicle_management/services/vehicle_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleService vehicleService;
  final ModelService modelService;

  VehicleBloc({required this.vehicleService, required this.modelService}) : super(VehicleInitial()) {
    on<FetchAllVehiclesFromOwnerIdEvent>(_onFetchAllVehiclesFromOwnerIdEvent);
    on<FetchVehicleByIdEvent>(_onFetchVehicleByIdEvent);
    on<CreateVehicleForOwnerIdEvent>(_onCreateVehicleForOwnerIdEvent);
    on<LoadVehicleCreateFormEvent>(_onLoadForm);
    on<SelectCreateBrandEvent>(_onSelectBrand);
    on<SelectCreateModelEvent>(_onSelectModel);
    on<UpdateCreatePlateEvent>(_onUpdateCreatePlate);
    on<UpdateCreateYearEvent>(_onUpdateCreateYear);
  }

  _onFetchAllVehiclesFromOwnerIdEvent(
      FetchAllVehiclesFromOwnerIdEvent event,
      Emitter<VehicleState> emit
      ) async {
    emit(VehicleLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? roleId = prefs.getInt('role_id');
      if (roleId != null) {
        final vehicles = await vehicleService.getVehiclesByOwnerId(roleId);
        emit(VehiclesLoaded(vehicles: vehicles));
      } else {
        throw Exception("Role Id not found");
      }
    } catch (e) {
      emit(VehicleError(message: "Failed to fetch vehicles: $e"));
    }
  }

  _onFetchVehicleByIdEvent(
      FetchVehicleByIdEvent event,
      Emitter<VehicleState> emit
      ) async {
    emit(VehicleLoading());
    try {
      final vehicle = await vehicleService.getVehicleById(event.vehicleId);
      emit(VehicleLoaded(vehicle: vehicle));
    } catch (e) {
      emit(VehicleError(message: "Failed to fetch vehicle with id ${event.vehicleId}: $e"));
    }
  }

  _onCreateVehicleForOwnerIdEvent(
      CreateVehicleForOwnerIdEvent event,
      Emitter<VehicleState> emit
      ) async {
    emit(VehicleLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? roleId = prefs.getInt('role_id');
      if (roleId != null) {
        final vehicle = await vehicleService.createVehicleForOwnerId(
            roleId,
            event.request
        );
        emit(VehicleCreated(vehicle: vehicle));
        final vehicles = await vehicleService.getVehiclesByOwnerId(roleId);
        emit(VehiclesLoaded(vehicles: vehicles));
      } else {
        throw Exception("Role Id not found");
      }
    } catch (e) {
      emit(VehicleError(message: "Failed to create vehicle: $e"));
    }
  }

  Future<void> _onLoadForm(
      LoadVehicleCreateFormEvent event,
      Emitter<VehicleState> emit,
      ) async {
    emit(VehicleCreateFormLoading());

    try {
      final models = await modelService.getAllModels();
      emit(
        VehicleCreateFormLoaded(
          allModels: models,
          filteredModels: const [],
          plate: '',
          year: null,
        ),
      );
    } catch (e) {
      emit(VehicleCreateFormError(e.toString()));
    }
  }

  void _onSelectBrand(
      SelectCreateBrandEvent event,
      Emitter<VehicleState> emit,
      ) {
    final current = state;

    if (current is! VehicleCreateFormLoaded) return;

    final filtered = current.allModels
        .where((m) => m.brand == event.brand)
        .toList();

    emit(
      current.copyWith(
        selectedBrand: event.brand,
        filteredModels: filtered,
        selectedModel: null,
      ),
    );
  }

  void _onSelectModel(
      SelectCreateModelEvent event,
      Emitter<VehicleState> emit,
      ) {
    final current = state;
    if (current is! VehicleCreateFormLoaded) return;

    emit(
      current.copyWith(selectedModel: event.model),
    );
  }

  _onUpdateCreatePlate(
      UpdateCreatePlateEvent event,
      Emitter<VehicleState> emit
      ) {
    final s = state as VehicleCreateFormLoaded;
    emit(s.copyWith(plate: event.plate));
  }

  _onUpdateCreateYear(
      UpdateCreateYearEvent event,
      Emitter<VehicleState> emit
      ) {
    final s = state as VehicleCreateFormLoaded;
    emit(s.copyWith(year: event.year));
  }

}