import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';
import '../app/theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/project_card.dart';
import '../widgets/skill_card.dart';
import '../widgets/empty_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _motivationalMessage() {
    final h = DateTime.now().hour;
    if (h < 12) return kMorningMessages[0];
    if (h < 17) return kAfternoonMessages[0];
    return kEveningMessages[0];
  }

  void _goToTab(BuildContext context, int i) =>
      Navigator.pushReplacementNamed(context, kRouteMain, arguments: i);

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            projectProvider.loadProjects(),
            skillProvider.loadSkills(),
            profileProvider.loadProfile(),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Hero / Welcome SliverAppBar ─────────────────────────────────
            SliverToBoxAdapter(
              child: _HeroCard(
                greeting: _greeting(),
                message: _motivationalMessage(),
                displayName: profileProvider.profile.name.isNotEmpty
                    ? profileProvider.profile.name
                    : 'Developer',
                projectCount: projectProvider.totalProjects,
                skillCount: skillProvider.totalSkills,
                onSettings: () => Navigator.pushNamed(context, kRouteSettings),
              ),
            ),

            // ── Stats Bento ─────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionLabel(title: 'Portfolio Stats'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _BentoStats(
                  projectProvider: projectProvider,
                  skillProvider: skillProvider,
                  onTap: (tab) => _goToTab(context, tab),
                ),
              ),
            ),

            // ── Quick Actions ───────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionLabel(title: 'Quick Actions'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _QuickActions(
                  onAddProject: () =>
                      Navigator.pushNamed(context, kRouteAddProject),
                  onAddSkill: () => _goToTab(context, 2),
                  onViewProjects: () => _goToTab(context, 1),
                  onEditProfile: () => _goToTab(context, 3),
                ),
              ),
            ),

            // ── Recent Projects ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(child: _SectionLabel(title: 'Recent Projects')),
                    TextButton(
                      onPressed: () => _goToTab(context, 1),
                      child: Text('View All',
                          style: TextStyle(color: cs.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
            if (projectProvider.recentProjects.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.folder_open_rounded,
                    title: 'No Projects Yet',
                    message: 'Tap "Add Project" to start tracking your work.',
                    actionLabel: 'Add Project',
                    onAction: () =>
                        Navigator.pushNamed(context, kRouteAddProject),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverList.separated(
                  itemCount: projectProvider.recentProjects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      ProjectCard(project: projectProvider.recentProjects[i]),
                ),
              ),

            // ── Top Skills ──────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(child: _SectionLabel(title: 'Top Skills')),
                    TextButton(
                      onPressed: () => _goToTab(context, 2),
                      child: Text('View All',
                          style: TextStyle(color: cs.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
            if (skillProvider.topSkills.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No skills added yet.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.separated(
                  itemCount: skillProvider.topSkills.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      SkillCard(skill: skillProvider.topSkills[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Hero Card ────────────────────────────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final String greeting;
  final String message;
  final String displayName;
  final int projectCount;
  final int skillCount;
  final VoidCallback onSettings;

  const _HeroCard({
    required this.greeting,
    required this.message,
    required this.displayName,
    required this.projectCount,
    required this.skillCount,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient(Theme.of(context).colorScheme),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings icon row
          Row(
            children: [
              Expanded(
                child: Text(
                  'CodeFolio Pro',
                  style: tt.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: Colors.white, size: 22),
                onPressed: onSettings,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$greeting,',
            style: tt.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            displayName,
            style: tt.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: tt.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 16),
          // Quick stats pills
          Row(
            children: [
              _HeroPill(icon: Icons.folder_rounded, label: '$projectCount Projects'),
              const SizedBox(width: 10),
              _HeroPill(icon: Icons.psychology_rounded, label: '$skillCount Skills'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
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

// ── Bento Stats ──────────────────────────────────────────────────────────────
class _BentoStats extends StatelessWidget {
  final ProjectProvider projectProvider;
  final SkillProvider skillProvider;
  final void Function(int tab) onTap;

  const _BentoStats({
    required this.projectProvider,
    required this.skillProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Use Row+Expanded instead of GridView to avoid aspect-ratio overflow
    return IntrinsicHeight(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: MetricCard(
                    label: 'Total Projects',
                    value: '${projectProvider.totalProjects}',
                    icon: Icons.folder_rounded,
                    iconColor: cs.primary,
                    onTap: () => onTap(1),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: MetricCard(
                    label: 'Completed',
                    value: '${projectProvider.completedProjects}',
                    icon: Icons.check_circle_rounded,
                    iconColor: const Color(0xFF10B981),
                    onTap: () => onTap(1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: MetricCard(
                    label: 'In Progress',
                    value: '${projectProvider.inProgressProjects}',
                    icon: Icons.pending_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    onTap: () => onTap(1),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: MetricCard(
                    label: 'Skills',
                    value: '${skillProvider.totalSkills}',
                    icon: Icons.psychology_rounded,
                    iconColor: cs.tertiary,
                    onTap: () => onTap(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final VoidCallback onAddProject;
  final VoidCallback onAddSkill;
  final VoidCallback onViewProjects;
  final VoidCallback onEditProfile;

  const _QuickActions({
    required this.onAddProject,
    required this.onAddSkill,
    required this.onViewProjects,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final actions = [
      (icon: Icons.add_circle_outline_rounded, label: 'Add Project',
        color: cs.primary, onTap: onAddProject),
      (icon: Icons.psychology_outlined, label: 'Add Skill',
        color: cs.tertiary, onTap: onAddSkill),
      (icon: Icons.folder_outlined, label: 'View Projects',
        color: const Color(0xFFF59E0B), onTap: onViewProjects),
      (icon: Icons.edit_outlined, label: 'Edit Profile',
        color: const Color(0xFF10B981), onTap: onEditProfile),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _ActionTile(action: actions[0])),
            const SizedBox(width: 12),
            Expanded(child: _ActionTile(action: actions[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _ActionTile(action: actions[2])),
            const SizedBox(width: 12),
            Expanded(child: _ActionTile(action: actions[3])),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final ({IconData icon, String label, Color color, VoidCallback onTap}) action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = cs.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? const Color(0xFF16213E) : cs.surface,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : cs.outline.withValues(alpha: 0.1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, size: 16, color: action.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  action.label,
                  style: tt.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
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
  }
}

// ── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                letterSpacing: -0.2,
              ),
        ),
      ],
    );
  }
}
