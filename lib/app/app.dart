import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';
import 'routes.dart';
import 'theme.dart';

class CodeFolioApp extends StatelessWidget {
  const CodeFolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => SkillProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: kAppName,
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            initialRoute: kRouteSplash,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
