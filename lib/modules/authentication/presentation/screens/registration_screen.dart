import 'package:fleety/core/utils/validation_helper.dart';
import 'package:fleety/core/widgets/common_progress_bar.dart';
import 'package:fleety/modules/authentication/data/models/registration_model.dart';
import 'package:fleety/modules/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:fleety/modules/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formFieldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationLoading) {
          CustomProgressBar(context).showLoadingIndicator();
        } else {
          CustomProgressBar(context).hideLoadingIndicator();
        }

        if (state is RegistrationSuccessfull) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successfull. Please login"),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Driver Register",
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
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
                controller: _userNameController,
                decoration: const InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                validator: (val) {
                  if (!Validator.validEmail(val)) {
                    return "Please fill this field";
                  }
                  return null;
                },
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                validator: (val) {
                  if (!Validator.validMobileNumber(val)) {
                    return "Please fill this field";
                  }
                  return null;
                },
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: "Phone number",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                validator: (val) {
                  if (!Validator.validField(val)) {
                    return "Please fill this field";
                  }
                  return null;
                },
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
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
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      RegisterTapped(
                        registrationModel: RegistrationModel(
                          password: _passwordController.text,
                          phoneNumber: _phoneController.text,
                          email: _emailController.text,
                          name: _userNameController.text,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already registered?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text("Login now"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
