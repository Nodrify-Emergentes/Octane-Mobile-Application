import 'package:octane_mobile/vehicle_management/model/vehicle_create_request.dart';

import '../../../model/vehicle_model.dart';

abstract class VehicleEvent {}

class FetchAllVehiclesFromOwnerIdEvent extends VehicleEvent {
  final int ownerId;

  FetchAllVehiclesFromOwnerIdEvent({
    required this.ownerId
  });
}

class CreateVehicleForOwnerIdEvent extends VehicleEvent {
  final VehicleCreateRequest request;

  CreateVehicleForOwnerIdEvent({
    required this.request
  });
}

class FetchVehicleByIdEvent extends VehicleEvent {
  final int vehicleId;

  FetchVehicleByIdEvent({
    required this.vehicleId
  });
}

class LoadVehicleCreateFormEvent extends VehicleEvent {}

class SelectCreateBrandEvent extends VehicleEvent {
  final String brand;
  SelectCreateBrandEvent(this.brand);
}

class SelectCreateModelEvent extends VehicleEvent {
  final Model model;
  SelectCreateModelEvent(this.model);
}

class UpdateCreatePlateEvent extends VehicleEvent {
  final String plate;
  UpdateCreatePlateEvent(this.plate);
}

class UpdateCreateYearEvent extends VehicleEvent {
  final String year;
  UpdateCreateYearEvent(this.year);
}
