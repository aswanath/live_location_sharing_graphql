part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class FetchedVehicleDetails extends HomeState {
  final VehicleDetailsModel vehicleDetailsModel;

  FetchedVehicleDetails({required this.vehicleDetailsModel});
}

class FetchedProfileDetails extends HomeState {
  final ProfileDetailsModel profileDetailsModel;

  FetchedProfileDetails({required this.profileDetailsModel});
}

class HomeLoading extends HomeState {}

class LocationSharedSuccessfully extends HomeState {
  final String latitude;
  final String longitude;

  LocationSharedSuccessfully({
    required this.longitude,
    required this.latitude,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({
    required this.message,
  });
}
