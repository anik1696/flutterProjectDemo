import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/profile_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../utils/constants.dart';
import '../app/theme.dart';
import 'onboarding_screen.dart';

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
      }
    } catch (_) {}
  }

  void _editProfile(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen(isEditing: true)));
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final tt = Theme.of(context).textTheme;
    final name = profile.name.isNotEmpty ? profile.name : 'Your Name';

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Clean AppBar ────────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppTheme.scaffoldBg,
            floating: false,
            pinned: true,
            title: const Text('Profile', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 28)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: AppTheme.primary),
                onPressed: () => _editProfile(context),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecond),
                onPressed: () => Navigator.pushNamed(context, kRouteSettings),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Profile Card ────────────────────────────────────────────
                Container(
                  decoration: AppTheme.cardDecoration,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                        child: Text(
                          _initials(name),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (profile.title.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile.title,
                          style: tt.bodyMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (profile.bio.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          profile.bio,
                          style: tt.bodyMedium?.copyWith(
                            color: AppTheme.textSecond,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Stats Row ────────────────────────────────────────────────
                Container(
                  decoration: AppTheme.cardDecoration,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(value: '${projectProvider.totalProjects}', label: 'Projects'),
                      Container(width: 1, height: 36, color: AppTheme.divider),
                      _StatItem(value: '${projectProvider.completedProjects}', label: 'Done'),
                      Container(width: 1, height: 36, color: AppTheme.divider),
                      _StatItem(value: '${skillProvider.totalSkills}', label: 'Skills'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Contact & Links ──────────────────────────────────────────
                if (profile.email.isNotEmpty || profile.githubUsername.isNotEmpty || profile.websiteUrl.isNotEmpty) ...[
                  Text('Connect', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      children: [
                        if (profile.email.isNotEmpty)
                          _LinkTile(
                            icon: Icons.alternate_email_rounded,
                            label: profile.email,
                            iconBg: AppTheme.iconBgBlue,
                            iconColor: AppTheme.info,
                          ),
                        if (profile.githubUsername.isNotEmpty) ...[
                          if (profile.email.isNotEmpty) const Divider(height: 1, indent: 68),
                          _LinkTile(
                            icon: Icons.code_rounded,
                            label: '@${profile.githubUsername}',
                            iconBg: AppTheme.iconBgPurple,
                            iconColor: AppTheme.purple,
                            onTap: profile.githubUrl.isNotEmpty ? () => _launchUrl(context, profile.githubUrl) : null,
                          ),
                        ],
                        if (profile.websiteUrl.isNotEmpty) ...[
                          const Divider(height: 1, indent: 68),
                          _LinkTile(
                            icon: Icons.language_rounded,
                            label: profile.websiteUrl,
                            iconBg: AppTheme.iconBgGreen,
                            iconColor: AppTheme.success,
                            onTap: () => _launchUrl(context, profile.websiteUrl),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Edit button ──────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _editProfile(context),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.primary)),
        const SizedBox(height: 2),
        Text(label, style: tt.labelSmall?.copyWith(color: AppTheme.textSecond, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback? onTap;
  const _LinkTile({required this.icon, required this.label, required this.iconBg, required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(label, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecond)
          : null,
    );
  }
}
