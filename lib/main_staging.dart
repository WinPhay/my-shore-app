import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_shorebird_app/config/flavors.dart';
import 'package:my_shorebird_app/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.appFlavor = Flavors.prod;
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}