import 'package:fleety/core/utils/validation_helper.dart';
import 'package:fleety/core/widgets/common_progress_bar.dart';
import 'package:fleety/modules/home/data/models/vehicle_details_model.dart';
import 'package:fleety/modules/home/presentation/bloc/home_bloc.dart';
import 'package:fleety/modules/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVehicleDetailsScreen extends StatefulWidget {
  const AddVehicleDetailsScreen({super.key});

  @override
  State<AddVehicleDetailsScreen> createState() => _AddVehicleDetailsScreenState();
}

class _AddVehicleDetailsScreenState extends State<AddVehicleDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final GlobalKey<FormState> _formFieldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoading) {
          CustomProgressBar(context).showLoadingIndicator();
        } else {
          CustomProgressBar(context).hideLoadingIndicator();
        }

        if (state is FetchedVehicleDetails) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Vehicle Details",
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
          key: _formFieldKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 48.0,
            ),
            children: [
              TextFormField(
                validator: (val) {
                  if (!Validator.validField(val)) {
                    return "Please fill this field";
                  }
                  return null;
                },
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  hintText: "Color",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  hintText: "Model",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  hintText: "Year",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(
                  hintText: "Licence Plate",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formFieldKey.currentState?.validate() ?? false) {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<HomeBloc>(context).add(
                      AddVehicleDetails(
                        vehicleDetailsModel: VehicleDetailsModel(
                          name: _nameController.text,
                          color: _colorController.text,
                          model: _modelController.text,
                          year: int.tryParse(_yearController.text),
                          licencePlate: _licensePlateController.text,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
