import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/profile_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import '../app/theme.dart';
import '../widgets/section_header.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen(isEditing: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Vibrant Header Background
                Container(
                  height: 200,
                  width: double.infinity,
                  color: AppTheme.primary,
                  child: SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.white),
                            onPressed: () => _editProfile(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_rounded, color: Colors.white),
                            onPressed: () => Navigator.pushNamed(context, kRouteSettings),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Overlapping Profile Info
                Container(
                  margin: const EdgeInsets.only(top: 130, left: 24, right: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                        child: Text(
                          _initials(profile.name),
                          style: tt.headlineMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.name.isNotEmpty ? profile.name : 'Your Name',
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (profile.title.isNotEmpty)
                        Text(
                          profile.title,
                          style: tt.bodyMedium?.copyWith(
                            color: AppTheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (profile.bio.isNotEmpty) ...[
                  Text(
                    'About Me',
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.bio,
                    style: tt.bodyMedium?.copyWith(color: AppTheme.textLight, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                ],

                if (profile.email.isNotEmpty || profile.githubUsername.isNotEmpty || profile.websiteUrl.isNotEmpty) ...[
                  Text(
                    'Connect',
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (profile.email.isNotEmpty)
                          _buildLinkTile(context, Icons.alternate_email_rounded, profile.email, null, tt),
                        if (profile.githubUsername.isNotEmpty)
                          _buildLinkTile(context, Icons.code_rounded, '@${profile.githubUsername}', profile.githubUrl, tt),
                        if (profile.websiteUrl.isNotEmpty)
                          _buildLinkTile(context, Icons.language_rounded, profile.websiteUrl, profile.websiteUrl, tt),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                Text(
                  'Stats Overview',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.textDark),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('${projectProvider.totalProjects}', 'Projects', tt),
                      Container(height: 40, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildStat('${projectProvider.completedProjects}', 'Completed', tt),
                      Container(height: 40, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildStat('${skillProvider.totalSkills}', 'Skills', tt),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(BuildContext context, IconData icon, String label, String? url, TextTheme tt) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppTheme.primary),
      ),
      title: Text(
        label,
        style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.textDark),
      ),
      trailing: url != null ? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textLight) : null,
      onTap: url != null ? () => _launchUrl(context, url) : null,
    );
  }

  Widget _buildStat(String value, String label, TextTheme tt) {
    return Column(
      children: [
        Text(
          value,
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: tt.labelMedium?.copyWith(
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
