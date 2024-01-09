import 'package:fleety/core/repository/ilocal_repository.dart';
import 'package:fleety/dependency_injection/injection_container.dart';
import 'package:fleety/modules/authentication/presentation/screens/login_screen.dart';
import 'package:fleety/modules/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    String? refreshToken = getIt<ILocalRepository>().getRefreshToken();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => (refreshToken != null && refreshToken.isNotEmpty) ? const HomeScreen() : const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text(
          "Fleety",
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
