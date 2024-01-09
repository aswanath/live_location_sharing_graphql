import 'package:fleety/core/utils/validation_helper.dart';
import 'package:fleety/core/widgets/common_progress_bar.dart';
import 'package:fleety/dependency_injection/injection_container.dart';
import 'package:fleety/modules/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:fleety/modules/authentication/presentation/screens/registration_screen.dart';
import 'package:fleety/modules/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is LoginSuccessful) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Driver Login",
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
                controller: _emailController,
                validator: (val) {
                  if (!Validator.validEmail(val)) {
                    return "Enter valid email";
                  }
                  return null;
                },
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
                  if (!Validator.validField(val)) {
                    return "Enter valid password";
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
                      LoginTapped(
                        password: _passwordController.text,
                        email: _emailController.text,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                ),
                child: const Text(
                  "Login",
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
                    "Not registered?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text("Register now"),
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
