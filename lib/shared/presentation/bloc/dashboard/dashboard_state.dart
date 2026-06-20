import 'package:octane_mobile/maintenance_and_operations/model/expense.dart';
import 'package:octane_mobile/maintenance_and_operations/model/maintenance.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({
    required this.message
  });
}

class DashboardLoaded extends DashboardState {
  final List<Vehicle> vehicles;
  final List<Maintenance> maintenances;
  final List<Expense> expenses;

  DashboardLoaded({
    required this.vehicles,
    required this.maintenances,
    required this.expenses
  });
}