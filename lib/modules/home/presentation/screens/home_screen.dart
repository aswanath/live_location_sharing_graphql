import 'dart:async';

import 'package:fleety/core/widgets/common_progress_bar.dart';
import 'package:fleety/modules/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:fleety/modules/authentication/presentation/screens/login_screen.dart';
import 'package:fleety/modules/home/data/models/profile_details_model.dart';
import 'package:fleety/modules/home/data/models/vehicle_details_model.dart';
import 'package:fleety/modules/home/presentation/bloc/home_bloc.dart';
import 'package:fleety/modules/home/presentation/screens/add_vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VehicleDetailsModel? _vehicleDetailsModel;
  ProfileDetailsModel? _profileDetailsModel;
  String? _locationCoordinates;
  bool _sharingLocation = false;
  StreamSubscription<Position>? positionStream;
  bool _permissionEnabled = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context)
      ..add(FetchVehicleDetails())
      ..add(FetchProfileDetails());
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<bool> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  void _shareLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if (position != null) {
        BlocProvider.of<HomeBloc>(context).add(
          UpdateLiveLocation(
            longitude: position.longitude.toString(),
            latitude: position.latitude.toString(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is LogoutSuccessful) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        drawer: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Drawer(
              child: SafeArea(
                child: _profileDetailsModel != null
                    ? Column(
                        children: [
                          const Text(
                            "My Profile details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          _DetailsRow(
                            title: "ID",
                            details: _profileDetailsModel!.id ?? "",
                          ),
                          _DetailsRow(
                            title: "Name",
                            details: _profileDetailsModel!.name ?? "",
                          ),
                          _DetailsRow(
                            title: "Status",
                            details: _profileDetailsModel!.status?.toString() ?? "",
                          ),
                          _DetailsRow(
                            title: "Email",
                            details: _profileDetailsModel!.email ?? "",
                          ),
                          _DetailsRow(
                            title: "Phone",
                            details: _profileDetailsModel!.phoneNumber ?? "",
                          ),
                        ],
                      )
                    : const Text("No data found"),
              ),
            );
          },
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              );
            },
          ),
          title: const Text(
            "Home Screen",
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthenticationBloc>(context).add(LogoutTapped());
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return FloatingActionButton.extended(
              onPressed: () async {
                if (_sharingLocation) {
                  positionStream?.pause();
                  setState(() {
                    _sharingLocation = false;
                  });
                } else {
                  _permissionEnabled = await _checkPermission();
                  if (_permissionEnabled) {
                    _shareLocation();
                  } else {
                    if (!mounted) return;

                    await showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text(
                          "Location permission not enabled. Please enable all permissions related to location",
                        ),
                      ),
                    );
                  }
                  // _shareLocation();
                  // CustomProgressBar(context).showLoadingIndicator();
                  // BlocProvider.of<HomeBloc>(context).add(
                  //   UpdateLiveLocation(
                  //     longitude: "23.45",
                  //     latitude: "72.1",
                  //   ),
                  // );
                }
              },
              label: Text("${_sharingLocation ? "Stop" : "Start"} Sharing Location"),
            );
          },
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoading) {
              CustomProgressBar(context).showLoadingIndicator();
            } else {
              CustomProgressBar(context).hideLoadingIndicator();
            }

            if (state is FetchedVehicleDetails) {
              _vehicleDetailsModel = state.vehicleDetailsModel;
            } else if (state is LocationSharedSuccessfully) {
              _sharingLocation = true;
              _locationCoordinates = "Latitude: ${state.latitude} , Longitude: ${state.longitude}";
            } else if (state is FetchedProfileDetails) {
              _profileDetailsModel = state.profileDetailsModel;
            }
          },
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32.0,
              ),
              children: [
                if (_vehicleDetailsModel != null) ...[
                  const Text(
                    "My vehicle details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  _DetailsRow(
                    title: "ID",
                    details: _vehicleDetailsModel!.id?.toString() ?? "",
                  ),
                  _DetailsRow(
                    title: "Name",
                    details: _vehicleDetailsModel!.name ?? "",
                  ),
                  _DetailsRow(
                    title: "Licence Plate",
                    details: _vehicleDetailsModel!.licencePlate ?? "",
                  ),
                  _DetailsRow(
                    title: "Model",
                    details: _vehicleDetailsModel!.model ?? "",
                  ),
                  _DetailsRow(
                    title: "Color",
                    details: _vehicleDetailsModel!.color ?? "",
                  ),
                  _DetailsRow(
                    title: "Year",
                    details: _vehicleDetailsModel!.year?.toString() ?? "",
                  ),
                ] else ...{
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddVehicleDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(
                        color: Colors.deepPurple.withOpacity(0.6),
                      ),
                    ),
                    child: const Text(
                      "Add Vehicle Details",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                },
                if (_locationCoordinates != null) ...[
                  const SizedBox(
                    height: 48,
                  ),
                  const Text(
                    "Last Shared Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    _locationCoordinates!,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String title;
  final String details;

  const _DetailsRow({
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return details.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
                children: [
                  TextSpan(
                    text: details,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
