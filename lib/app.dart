import 'package:fleety/dependency_injection/injection_container.dart';
import 'package:fleety/modules/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:fleety/modules/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/home/presentation/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc = getIt<AuthenticationBloc>();
    final HomeBloc homeBloc = getIt<HomeBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => authenticationBloc,
        ),
        BlocProvider(
          create: (context) => homeBloc,
        ),
      ],
      child: MaterialApp(
        title: 'Fleety',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
