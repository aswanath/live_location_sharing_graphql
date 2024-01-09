import 'package:fleety/core/model/network_response_model.dart';
import 'package:fleety/core/repository/iremote_repository.dart';
import 'package:fleety/modules/home/data/models/profile_details_model.dart';
import 'package:fleety/modules/home/data/models/vehicle_details_model.dart';
import 'package:fleety/modules/home/data/network/home_api.dart';
import 'package:fleety/modules/home/data/respository/ihome_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IHomeRepository)
class HomeRepository extends IHomeRepository {
  final HomeAPI _homeAPI;

  HomeRepository(this._homeAPI);

  @override
  Future<NetworkResponseModel<VehicleDetailsModel>> fetchVehicleDetails() {
    return _homeAPI.fetchVehicleDetails();
  }

  @override
  Future<NetworkResponseModel<VehicleDetailsModel>> createVehicle({
    required VehicleDetailsModel vehicleDetailsModel,
  }) {
    return _homeAPI.createVehicle(
      vehicleDetailsModel: vehicleDetailsModel,
    );
  }

  @override
  Future<NetworkResponseModel<String>> updateLocation({
    required String latitude,
    required String longitude,
  }) {
    return _homeAPI.updateLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<NetworkResponseModel<ProfileDetailsModel>> fetchProfileDetails() {
    return _homeAPI.fetchProfileDetails();
  }
}
