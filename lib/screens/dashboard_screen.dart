import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../providers/profile_provider.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../utils/constants.dart';
import '../widgets/metric_card.dart';
import '../widgets/project_card.dart';
import '../widgets/skill_card.dart';
import '../widgets/section_header.dart';
import '../widgets/empty_state.dart';

/// The Dashboard tab — the first screen users see after launch.
///
/// Shows a personalised welcome card, portfolio statistics, quick-action
/// shortcuts, the three most-recent projects, and the top five skills by
/// proficiency. All data is read from the Provider tree; no local state is
/// required beyond what the providers hold.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ── Time-of-day helpers ────────────────────────────────────────────────────

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _motivationalMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return kMorningMessages[0];
    if (hour < 17) return kAfternoonMessages[0];
    return kEveningMessages[0];
  }

  // ── Navigation helpers ─────────────────────────────────────────────────────

  void _goToTab(BuildContext context, int tabIndex) {
    Navigator.pushReplacementNamed(
      context,
      kRouteMain,
      arguments: tabIndex,
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();

    final profile = profileProvider.profile;
    final recentProjects = projectProvider.recentProjects;
    final topSkills = skillProvider.topSkills;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeFolio Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, kRouteSettings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Providers are already reactive; a lightweight reload is sufficient.
          await Future.wait([
            projectProvider.loadProjects(),
            skillProvider.loadSkills(),
            profileProvider.loadProfile(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1 — Welcome card
              _buildWelcomeCard(context, profile, projectProvider, skillProvider),

              const SizedBox(height: 20),

              // 2 — Portfolio stats
              const SectionHeader(title: 'Portfolio Stats'),
              const SizedBox(height: 8),
              _buildStats(context, projectProvider, skillProvider),

              const SizedBox(height: 20),

              // 3 — Quick actions
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 8),
              _buildQuickActions(context),

              const SizedBox(height: 20),

              // 4 — Recent projects
              SectionHeader(
                title: 'Recent Projects',
                actionLabel: 'View All',
                onAction: () => _goToTab(context, 1),
              ),
              const SizedBox(height: 8),
              _buildRecentProjects(context, recentProjects),

              const SizedBox(height: 20),

              // 5 — Top skills
              SectionHeader(
                title: 'Top Skills',
                actionLabel: 'View All',
                onAction: () => _goToTab(context, 2),
              ),
              const SizedBox(height: 8),
              _buildTopSkills(context, topSkills),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Welcome card ───────────────────────────────────────────────────────────

  Widget _buildWelcomeCard(
    BuildContext context,
    dynamic profile,
    ProjectProvider projectProvider,
    SkillProvider skillProvider,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayName = profile.name.isNotEmpty ? profile.name : 'Developer';

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scheme.primary, scheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_greeting()}, $displayName 👋',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _motivationalMessage(),
              style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _WelcomeChip(
                  label: '${projectProvider.totalProjects} Projects',
                  icon: Icons.folder_rounded,
                ),
                const SizedBox(width: 8),
                _WelcomeChip(
                  label: '${skillProvider.totalSkills} Skills',
                  icon: Icons.psychology_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Stats grid ─────────────────────────────────────────────────────────────

  Widget _buildStats(
    BuildContext context,
    ProjectProvider projectProvider,
    SkillProvider skillProvider,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        MetricCard(
          label: 'Total Projects',
          value: '${projectProvider.totalProjects}',
          icon: Icons.folder_rounded,
          iconColor: scheme.primary,
          onTap: () => _goToTab(context, 1),
        ),
        MetricCard(
          label: 'Completed',
          value: '${projectProvider.completedProjects}',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
          onTap: () => _goToTab(context, 1),
        ),
        MetricCard(
          label: 'In Progress',
          value: '${projectProvider.inProgressProjects}',
          icon: Icons.pending_rounded,
          iconColor: Colors.orange,
          onTap: () => _goToTab(context, 1),
        ),
        MetricCard(
          label: 'Skills',
          value: '${skillProvider.totalSkills}',
          icon: Icons.psychology_rounded,
          iconColor: scheme.tertiary,
          onTap: () => _goToTab(context, 2),
        ),
      ],
    );
  }

  // ── Quick actions grid ─────────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final actions = [
      (
        icon: Icons.add_circle_outline_rounded,
        label: 'Add Project',
        color: scheme.primary,
        onTap: () => Navigator.pushNamed(context, kRouteAddProject),
      ),
      (
        icon: Icons.psychology_outlined,
        label: 'Add Skill',
        color: scheme.tertiary,
        onTap: () => _goToTab(context, 2),
      ),
      (
        icon: Icons.folder_outlined,
        label: 'View Projects',
        color: Colors.orange,
        onTap: () => _goToTab(context, 1),
      ),
      (
        icon: Icons.edit_outlined,
        label: 'Edit Profile',
        color: Colors.green,
        onTap: () => _goToTab(context, 3),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: actions.map((action) {
        return Card(
          child: InkWell(
            onTap: action.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(action.icon, color: action.color, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      action.label,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Recent projects ────────────────────────────────────────────────────────

  Widget _buildRecentProjects(
    BuildContext context,
    List<Project> recentProjects,
  ) {
    if (recentProjects.isEmpty) {
      return EmptyState(
        icon: Icons.folder_open_rounded,
        title: 'No Projects Yet',
        message: 'Tap "Add Project" to start tracking your work.',
        actionLabel: 'Add Project',
        onAction: () => Navigator.pushNamed(context, kRouteAddProject),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < recentProjects.length; i++) ...[
          ProjectCard(project: recentProjects[i]),
          if (i < recentProjects.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ── Top skills ─────────────────────────────────────────────────────────────

  Widget _buildTopSkills(BuildContext context, List<Skill> topSkills) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    if (topSkills.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No skills added yet. Head to the Skills tab to get started!',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: topSkills.map((skill) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SkillCard(skill: skill),
        );
      }).toList(),
    );
  }
}

// ── Private helper widget ──────────────────────────────────────────────────

/// A small chip displayed inside the welcome card to surface key stats.
class _WelcomeChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _WelcomeChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
