import '../models/project.dart';
import '../models/skill.dart';
import '../models/user_profile.dart';
import 'local_storage_service.dart';

class DataSeeder {
  static Future<void> seedIfNeeded() async {
    final storage = LocalStorageService();
    // Always re-seed profile to keep it up to date


    // 1. Seed Profile
    await storage.saveProfile(UserProfile(
      name: 'Sahreyar Ahmed',
      title: 'Flutter Developer',
      bio: 'Passionate Flutter developer crafting high-performance, beautiful mobile experiences.',
      email: 'sahreyar@example.com',
      githubUsername: 'anik1696',
      githubUrl: 'https://github.com/anik1696',
      websiteUrl: 'https://sahreyar.dev',
      isProfileComplete: true,
    ));

    // 2. Seed Projects
    await storage.saveProjects([
      Project(
        id: 'p1',
        title: 'Fintech Dashboard',
        description: 'A comprehensive financial dashboard tracking real-time crypto and stock market movements using WebSockets.',
        category: 'Freelance',
        technologies: ['Flutter', 'Dart', 'WebSockets', 'Riverpod'],
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        githubUrl: 'https://github.com/alexdev/fintech',
        liveDemoUrl: 'https://fintech.example.com',
      ),
      Project(
        id: 'p2',
        title: 'HealthSync',
        description: 'A telemedicine application connecting patients with doctors securely. Features HIPAA-compliant chat and video calling.',
        category: 'Open Source',
        technologies: ['Flutter', 'Firebase', 'WebRTC', 'Cloud Functions'],
        status: 'In Progress',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        githubUrl: 'https://github.com/alexdev/healthsync',
      ),
      Project(
        id: 'p3',
        title: 'Smart Home Hub',
        description: 'IoT controller app managing smart lights, thermostats, and security cameras over local MQTT networks.',
        category: 'Personal',
        technologies: ['Flutter', 'MQTT', 'Provider', 'SQLite'],
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      Project(
        id: 'p4',
        title: 'E-Commerce App',
        description: 'A full-stack e-commerce solution with Stripe integration, cart management, and push notifications.',
        category: 'Freelance',
        technologies: ['Flutter', 'Node.js', 'Stripe', 'MongoDB'],
        status: 'Archived',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
    ]);

    // 3. Seed Skills
    await storage.saveSkills([
      Skill(id: 's1', name: 'Flutter', category: 'Framework', proficiency: 'Expert', yearsExperience: 4.5),
      Skill(id: 's2', name: 'Dart', category: 'Programming Language', proficiency: 'Expert', yearsExperience: 4.5),
      Skill(id: 's3', name: 'Firebase', category: 'Cloud & DevOps', proficiency: 'Advanced', yearsExperience: 3.0),
      Skill(id: 's4', name: 'Node.js', category: 'Backend', proficiency: 'Intermediate', yearsExperience: 2.0),
      Skill(id: 's5', name: 'SQL / PostgreSQL', category: 'Database', proficiency: 'Advanced', yearsExperience: 3.5),
      Skill(id: 's6', name: 'UI/UX Design', category: 'Tool', proficiency: 'Intermediate', yearsExperience: 1.5),
      Skill(id: 's7', name: 'Git & GitHub', category: 'Tool', proficiency: 'Expert', yearsExperience: 5.0),
    ]);

    // Mark as setup
    await storage.setProfileSetup(true);
  }
}
