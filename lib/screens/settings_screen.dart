import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../providers/profile_provider.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';
import '../widgets/coming_soon_dialog.dart';

/// App settings screen — theme, coming-soon features, data reset, and about.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeader(BuildContext context, String title) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _comingSoonTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: () => ComingSoonDialog.show(context, featureName: title),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will permanently remove your profile, projects and skills. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await LocalStorageService().clearAll();
      context.read<ProjectProvider>().clearAll();
      context.read<SkillProvider>().clearAll();
      await context.read<ProfileProvider>().clearProfile();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          kRouteOnboarding,
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Appearance ───────────────────────────────────────────────────
          _sectionHeader(context, 'Appearance'),
          const Divider(height: 1),
          Consumer<ThemeProvider>(
            builder: (ctx, themeProvider, _) => ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Theme'),
              subtitle: Text(
                themeProvider.themeModeString[0].toUpperCase() +
                    themeProvider.themeModeString.substring(1),
              ),
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'light',
                    icon: Icon(Icons.light_mode_rounded, size: 18),
                    tooltip: 'Light',
                  ),
                  ButtonSegment(
                    value: 'system',
                    icon: Icon(Icons.brightness_auto_rounded, size: 18),
                    tooltip: 'System',
                  ),
                  ButtonSegment(
                    value: 'dark',
                    icon: Icon(Icons.dark_mode_rounded, size: 18),
                    tooltip: 'Dark',
                  ),
                ],
                selected: {themeProvider.themeModeString},
                onSelectionChanged: (sel) =>
                    themeProvider.setThemeMode(sel.first),
                style: SegmentedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
            ),
          ),

          // ── Coming Soon ──────────────────────────────────────────────────
          const Divider(height: 1),
          _sectionHeader(context, 'Coming Soon'),
          const Divider(height: 1),
          _comingSoonTile(
            context,
            icon: Icons.html_rounded,
            title: 'Web Portfolio Export',
            subtitle: 'Generate an HTML/JSON portfolio from your data.',
          ),
          _comingSoonTile(
            context,
            icon: Icons.insights_rounded,
            title: 'GitHub Insights',
            subtitle: 'View commits, stars and pull requests.',
          ),
          _comingSoonTile(
            context,
            icon: Icons.terminal_rounded,
            title: 'Code Snippet Sandbox',
            subtitle: 'Write and preview code snippets.',
          ),
          _comingSoonTile(
            context,
            icon: Icons.cloud_sync_rounded,
            title: 'Cloud Sync',
            subtitle: 'Sync your portfolio across devices.',
          ),

          // ── Data Management ──────────────────────────────────────────────
          const Divider(height: 1),
          _sectionHeader(context, 'Data Management'),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: scheme.error),
            title: Text(
              'Reset All Data',
              style: TextStyle(color: scheme.error),
            ),
            subtitle: const Text(
              'Permanently remove all profile, projects and skills.',
            ),
            onTap: () => _confirmReset(context),
          ),

          // ── About ────────────────────────────────────────────────────────
          const Divider(height: 1),
          _sectionHeader(context, 'About'),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.code_rounded,
                size: 20,
                color: scheme.onPrimaryContainer,
              ),
            ),
            title: const Text(kAppName),
            subtitle: Text('Version $kAppVersion • Track. Build. Showcase.'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
