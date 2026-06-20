import 'package:octane_mobile/vehicle_management/model/vehicle_model.dart';

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleError extends VehicleState {
  final String message;

  VehicleError({
    required this.message
  });
}

class VehiclesLoaded extends VehicleState {
  final List<Vehicle> vehicles;

  VehiclesLoaded({
    required this.vehicles
  });
}

class VehicleLoaded extends VehicleState {
  final Vehicle vehicle;

  VehicleLoaded({
    required this.vehicle
  });
}

class VehicleCreated extends VehicleState {
  final Vehicle vehicle;

  VehicleCreated({
    required this.vehicle
  });
}

class VehicleCreateFormLoading extends VehicleState {}

class VehicleCreateFormLoaded extends VehicleState {
  final List<Model> allModels;
  final List<Model> filteredModels;
  final String? selectedBrand;
  final Model? selectedModel;
  final String plate;
  final String? year;

  VehicleCreateFormLoaded({
    required this.allModels,
    required this.filteredModels,
    this.selectedBrand,
    this.selectedModel,
    this.plate = '',
    this.year,
  });

  VehicleCreateFormLoaded copyWith({
    List<Model>? allModels,
    List<Model>? filteredModels,
    String? selectedBrand,
    Model? selectedModel,
    String? plate,
    String? year,
  }) {
    return VehicleCreateFormLoaded(
      allModels: allModels ?? this.allModels,
      filteredModels: filteredModels ?? this.filteredModels,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      plate: plate ?? this.plate,
      year: year ?? this.year,
    );
  }
}

class VehicleCreateFormError extends VehicleState {
  final String message;

  VehicleCreateFormError(this.message);
}