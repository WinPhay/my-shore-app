import 'package:flutter/material.dart';
import 'package:my_shorebird_app/config/flavors.dart';
import 'package:my_shorebird_app/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.appFlavor = Flavors.dev;
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}