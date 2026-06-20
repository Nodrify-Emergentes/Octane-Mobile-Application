import 'package:octane_mobile/maintenance_and_operations/model/maintenance.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:octane_mobile/iam/models/user.dart';

class MaintenanceCard {
  final Maintenance maintenance;
  final Vehicle? vehicle;
  final User? mechanic;

  MaintenanceCard({
    required this.maintenance,
    this.vehicle,
    this.mechanic,
  });

  MaintenanceCard copyWith({
    Maintenance? maintenance,
    Vehicle? vehicle,
    User? mechanic,
  }) {
    return MaintenanceCard(
      maintenance: maintenance ?? this.maintenance,
      vehicle: vehicle ?? this.vehicle,
      mechanic: mechanic ?? this.mechanic,
    );
  }
}

