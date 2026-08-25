import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'services/local_storage_service.dart';
import 'models/user_profile.dart';
import 'models/project.dart';
import 'models/skill.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation for phone-first design
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await LocalStorageService().init();
  runApp(const CodeFolioApp());
}
