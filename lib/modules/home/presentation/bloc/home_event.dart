part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchVehicleDetails extends HomeEvent {}

class FetchProfileDetails extends HomeEvent {}

class AddVehicleDetails extends HomeEvent {
  final VehicleDetailsModel vehicleDetailsModel;

  AddVehicleDetails({required this.vehicleDetailsModel});
}

class UpdateLiveLocation extends HomeEvent {
  final String latitude;
  final String longitude;

  UpdateLiveLocation({
    required this.longitude,
    required this.latitude,
  });
}
