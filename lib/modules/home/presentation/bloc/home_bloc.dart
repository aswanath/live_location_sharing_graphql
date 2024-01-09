import 'dart:async';
import 'package:fleety/modules/home/data/models/profile_details_model.dart';
import 'package:fleety/modules/home/data/models/vehicle_details_model.dart';
import 'package:fleety/modules/home/data/respository/ihome_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';

part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository _homeRepository;

  HomeBloc(
    this._homeRepository,
  ) : super(HomeInitial()) {
    on<FetchVehicleDetails>(_onFetchVehicleDetails);
    on<AddVehicleDetails>(_onAddVehicleDetails);
    on<UpdateLiveLocation>(_onUpdateLiveLocation);
    on<FetchProfileDetails>(_onFetchProfileDetails);
  }

  FutureOr<void> _onFetchProfileDetails(FetchProfileDetails event, emit) async {
    final result = await _homeRepository.fetchProfileDetails();
    if (result.data != null) {
      emit(
        FetchedProfileDetails(profileDetailsModel: result.data!),
      );
    }
  }

  FutureOr<void> _onUpdateLiveLocation(UpdateLiveLocation event, emit) async {
    final result = await _homeRepository.updateLocation(
      latitude: event.latitude,
      longitude: event.longitude,
    );
    emit(
      LocationSharedSuccessfully(latitude: event.latitude, longitude: event.longitude),
    );
    print(result.data);
  }

  FutureOr<void> _onAddVehicleDetails(AddVehicleDetails event, emit) async {
    emit(HomeLoading());
    final result = await _homeRepository.createVehicle(
      vehicleDetailsModel: event.vehicleDetailsModel,
    );
    if (result.data != null) {
      emit(
        FetchedVehicleDetails(vehicleDetailsModel: result.data!),
      );
    } else {
      emit(
        HomeError(message: result.message),
      );
    }
  }

  FutureOr<void> _onFetchVehicleDetails(FetchVehicleDetails event, emit) async {
    emit(HomeLoading());
    final result = await _homeRepository.fetchVehicleDetails();
    if (result.data != null) {
      emit(
        FetchedVehicleDetails(vehicleDetailsModel: result.data!),
      );
    } else {
      emit(HomeError(message: ""));
    }
  }
}
