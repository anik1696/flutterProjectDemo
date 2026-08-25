import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/profile_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import '../widgets/section_header.dart';
import 'onboarding_screen.dart';

/// Profile tab — shows the user's developer profile card, stats, and links.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open link')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid URL')),
        );
      }
    }
  }

  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(isEditing: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: scheme.surface,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
                onPressed: () => Navigator.pushNamed(context, kRouteSettings),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
                onPressed: () => _editProfile(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                color: scheme.surface,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: scheme.surfaceContainerHighest,
                        child: Text(
                          _initials(profile.name),
                          style: textTheme.headlineSmall?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.name.isNotEmpty ? profile.name : 'Your Name',
                        style: textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (profile.title.isNotEmpty)
                        Text(
                          profile.title,
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Body content ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bio
                  if (profile.bio.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(title: 'About'),
                            const SizedBox(height: 8),
                            Text(profile.bio, style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Contact & Links
                  if (profile.email.isNotEmpty ||
                      profile.githubUsername.isNotEmpty ||
                      profile.websiteUrl.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: SectionHeader(title: 'Contact & Links'),
                            ),
                            if (profile.email.isNotEmpty)
                              _buildLinkTile(
                                context,
                                Icons.email_outlined,
                                profile.email,
                                null,
                              ),
                            if (profile.githubUsername.isNotEmpty)
                              _buildLinkTile(
                                context,
                                Icons.code_rounded,
                                '@${profile.githubUsername}',
                                profile.githubUrl.isNotEmpty
                                    ? profile.githubUrl
                                    : null,
                              ),
                            if (profile.websiteUrl.isNotEmpty)
                              _buildLinkTile(
                                context,
                                Icons.language_rounded,
                                profile.websiteUrl,
                                profile.websiteUrl,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Portfolio Stats
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(title: 'Portfolio Stats'),
                          const SizedBox(height: 16),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                _buildStat(
                                  context,
                                  '${projectProvider.totalProjects}',
                                  'Projects',
                                ),
                                VerticalDivider(
                                  color: scheme.outlineVariant,
                                  thickness: 1,
                                ),
                                _buildStat(
                                  context,
                                  '${projectProvider.completedProjects}',
                                  'Completed',
                                ),
                                VerticalDivider(
                                  color: scheme.outlineVariant,
                                  thickness: 1,
                                ),
                                _buildStat(
                                  context,
                                  '${skillProvider.totalSkills}',
                                  'Skills',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit profile button
                  FilledButton.tonal(
                    onPressed: () => _editProfile(context),
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 8),

                  // Settings button
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, kRouteSettings),
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Settings'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(
    BuildContext context,
    IconData icon,
    String label,
    String? url,
  ) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      trailing: url != null
          ? const Icon(Icons.open_in_new_rounded, size: 16)
          : null,
      onTap: url != null ? () => _launchUrl(context, url) : null,
      dense: true,
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
