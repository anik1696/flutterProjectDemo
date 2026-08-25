import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'services/local_storage_service.dart';
import 'services/data_seeder.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation for phone-first design
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await LocalStorageService().init();
  await DataSeeder.seedIfNeeded();
  
  runApp(const CodeFolioApp());
}
