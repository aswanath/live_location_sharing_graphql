import 'package:fleety/core/model/network_response_model.dart';
import 'package:fleety/modules/home/data/models/profile_details_model.dart';
import 'package:fleety/modules/home/data/models/vehicle_details_model.dart';

abstract class IHomeRepository {
  Future<NetworkResponseModel<VehicleDetailsModel>> fetchVehicleDetails();
  Future<NetworkResponseModel<VehicleDetailsModel>> createVehicle({
    required VehicleDetailsModel vehicleDetailsModel,
  });
  Future<NetworkResponseModel<String>> updateLocation({
    required String latitude,
    required String longitude,
  });
  Future<NetworkResponseModel<ProfileDetailsModel>> fetchProfileDetails();
}
