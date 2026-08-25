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
  
  if (!LocalStorageService().isProfileSetup()) {
    await LocalStorageService().setProfileSetup(true);
    await LocalStorageService().saveProfile(UserProfile(
      name: 'Anik Developer',
      title: 'Senior Flutter Engineer',
      bio: 'Passionate about creating beautiful, high-performance cross-platform applications using Flutter and Dart.',
      email: 'hello@anik.dev',
      githubUsername: 'anik1696',
    ));
    await LocalStorageService().saveProjects([
      Project(id: '1', title: 'CodeFolio Pro', description: 'A beautiful portfolio tracker app built with Flutter.', category: 'Open Source', technologies: ['Flutter', 'Dart', 'Provider'], status: 'Completed', createdAt: DateTime.now()),
      Project(id: '2', title: 'E-Commerce App', description: 'Full-stack shopping app with Stripe integration.', category: 'Freelance', technologies: ['Flutter', 'Firebase', 'Node.js'], status: 'In Progress', createdAt: DateTime.now()),
    ]);
    await LocalStorageService().saveSkills([
      Skill(id: '1', name: 'Flutter', category: 'Framework', proficiency: 'Expert'),
      Skill(id: '2', name: 'Dart', category: 'Programming Language', proficiency: 'Advanced'),
      Skill(id: '3', name: 'Firebase', category: 'Cloud & DevOps', proficiency: 'Intermediate'),
    ]);
  }

  runApp(const CodeFolioApp());
}
