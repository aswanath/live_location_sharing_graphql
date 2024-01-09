import 'package:flutter/material.dart';

import 'app.dart';
import 'dependency_injection/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt.allReady();
  runApp(const MyApp());
}
