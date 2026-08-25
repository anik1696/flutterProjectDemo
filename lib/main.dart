import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'services/local_storage_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation for phone-first design
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize local storage before app starts
  await LocalStorageService().init();
  runApp(const CodeFolioApp());
}
