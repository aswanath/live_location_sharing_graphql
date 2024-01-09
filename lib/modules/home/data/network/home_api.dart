import 'package:fleety/core/model/network_response_model.dart';
import 'package:fleety/core/repository/iremote_repository.dart';
import 'package:fleety/modules/home/data/models/profile_details_model.dart';
import 'package:fleety/modules/home/data/models/vehicle_details_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

const String _kFetchVehicleKey = "fetchVehicle";
const String _kCreateVehicleKey = "vehicleCreate";
const String _kVehicleKey = "vehicle";
const String _kLatitude = "latitude";
const String _kLongitude = "longitude";
const String _kShareLocationKey = "shareLocation";
const String _kMessage = "message";
const String _kMe = "me";

@injectable
class HomeAPI {
  final IRemoteRepository _remoteRepository;

  HomeAPI(this._remoteRepository);

  final String _fetchVehicleQueryString = """
  {
  fetchVehicle {
    color
    id
    licencePlate
    model
    name
    year
  }
}
  """;

  final String _createVehicleMutationString = r"""
  mutation($name: String!, $model: String, $year: String, $licencePlate: String, $color: String) {
  vehicleCreate(input: { params: { name: $name, model: $model, year: $year, licencePlate: $licencePlate,color: $color} }) {
    vehicle {
      color
      id
      licencePlate
      model
      name
      year
    }
  }
}
  """;

  final String _updateLocationMutationString = r"""
  mutation($latitude: String!, $longitude: String!) {
  shareLocation(input: { latitude: $latitude, longitude: $longitude }) {
    message
  }
}
  """;

  final String _fetchProfileQueryString = """
  {
  me {
    email
    id
    name
    phoneNumber
    status
  }
}
  """;

  Future<NetworkResponseModel<String>> updateLocation({
    required String latitude,
    required String longitude,
  }) async {
    var response = await _remoteRepository.mutation(
      mutationString: _updateLocationMutationString,
      variables: {
        _kLatitude: latitude,
        _kLongitude: longitude,
      },
    );
    return NetworkResponseModel<String>.process(
      response,
      (resultMap) {
        if (resultMap?[_kShareLocationKey] != null) {
          return resultMap![_kShareLocationKey][_kMessage];
        }
        return null;
      },
    );
  }

  Future<NetworkResponseModel<VehicleDetailsModel>> fetchVehicleDetails() async {
    var response = await _remoteRepository.query(
      queryString: _fetchVehicleQueryString,
      useAuth: true,
    );
    return NetworkResponseModel<VehicleDetailsModel>.process(
      response,
      (resultMap) {
        if (resultMap?[_kFetchVehicleKey] != null) {
          return VehicleDetailsModel.fromJson(resultMap![_kFetchVehicleKey]);
        }
        return null;
      },
    );
  }

  Future<NetworkResponseModel<ProfileDetailsModel>> fetchProfileDetails() async {
    var response = await _remoteRepository.query(
      queryString: _fetchProfileQueryString,
      useAuth: true,
    );
    return NetworkResponseModel<ProfileDetailsModel>.process(
      response,
      (resultMap) {
        if (resultMap?[_kMe] != null) {
          return ProfileDetailsModel.fromJson(resultMap![_kMe]);
        }
        return null;
      },
    );
  }

  Future<NetworkResponseModel<VehicleDetailsModel>> createVehicle({
    required VehicleDetailsModel vehicleDetailsModel,
  }) async {
    var response = await _remoteRepository.mutation(
      mutationString: _createVehicleMutationString,
      variables: vehicleDetailsModel.toJson(),
    );
    return NetworkResponseModel<VehicleDetailsModel>.process(
      response,
      (resultMap) {
        if (resultMap?[_kCreateVehicleKey] != null) {
          return VehicleDetailsModel.fromJson(resultMap![_kCreateVehicleKey][_kVehicleKey]);
        }
        return null;
      },
    );
  }
}
