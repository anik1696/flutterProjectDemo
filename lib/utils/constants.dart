// Keys for SharedPreferences
const String kProfileKey = 'user_profile';
const String kProjectsKey = 'projects';
const String kSkillsKey = 'skills';
const String kThemeModeKey = 'theme_mode';
const String kIsProfileSetup = 'is_profile_setup';

// Project statuses
const String kStatusInProgress = 'In Progress';
const String kStatusCompleted = 'Completed';
const String kStatusArchived = 'Archived';
const List<String> kProjectStatuses = [
  kStatusInProgress,
  kStatusCompleted,
  kStatusArchived,
];

// Project categories
const List<String> kProjectCategories = [
  'Academic',
  'Personal',
  'Freelance',
  'Open Source',
  'Other',
];

// Skill categories
const List<String> kSkillCategories = [
  'Programming Language',
  'Framework',
  'Database',
  'Tool',
  'Cloud & DevOps',
  'Other',
];

// Skill proficiency levels
const String kProficiencyBeginner = 'Beginner';
const String kProficiencyIntermediate = 'Intermediate';
const String kProficiencyAdvanced = 'Advanced';
const String kProficiencyExpert = 'Expert';
const List<String> kProficiencyLevels = [
  kProficiencyBeginner,
  kProficiencyIntermediate,
  kProficiencyAdvanced,
  kProficiencyExpert,
];

// App info
const String kAppName = 'CodeFolio Pro';
const String kAppTagline = 'Track. Build. Showcase.';
const String kAppVersion = '1.0.0';

// Motivational messages by time of day
const List<String> kMorningMessages = [
  'Start your day with great code! ☕',
  'A new day, a new commit. Make it count! 🚀',
  'Good things take time. Keep building! 🛠️',
];
const List<String> kAfternoonMessages = [
  'Keep the momentum going! ⚡',
  'You are halfway through. Push forward! 💪',
  'Great code takes time. Stay focused! 🎯',
];
const List<String> kEveningMessages = [
  'Wrap up well. What did you ship today? 🌙',
  'Review your progress. Every bit counts! ✨',
  'Another productive day. Well done! 🌟',
];

// Route names
const String kRouteSplash = '/';
const String kRouteOnboarding = '/onboarding';
const String kRouteMain = '/main';
const String kRouteProjectDetails = '/project/details';
const String kRouteAddProject = '/project/add';
const String kRouteEditProject = '/project/edit';
const String kRouteSettings = '/settings';
