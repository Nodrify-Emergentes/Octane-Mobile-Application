import 'package:octane_mobile/maintenance_and_operations/model/maintenance.dart';
import 'package:octane_mobile/maintenance_and_operations/model/maintenance_card.dart';

abstract class MaintenanceState {}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceLoaded extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceLoaded(this.maintenance);
}

class MaintenancesLoaded extends MaintenanceState {
  final List<Maintenance> maintenances;

  MaintenancesLoaded(this.maintenances);
}

class MaintenanceCardsLoaded extends MaintenanceState {
  final List<MaintenanceCard> scheduledMaintenances;
  final List<MaintenanceCard> completedMaintenances;

  MaintenanceCardsLoaded({
    required this.scheduledMaintenances,
    required this.completedMaintenances,
  });
}

class MaintenanceCreated extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceCreated(this.maintenance);
}

class MaintenanceDeleted extends MaintenanceState {}

class MaintenanceStatusUpdated extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceStatusUpdated(this.maintenance);
}

class MaintenanceExpenseAssigned extends MaintenanceState {
  final Maintenance maintenance;

  MaintenanceExpenseAssigned(this.maintenance);
}

class MaintenanceError extends MaintenanceState {
  final String message;

  MaintenanceError(this.message);
}

