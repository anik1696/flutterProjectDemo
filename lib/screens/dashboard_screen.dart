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

  void _goToTab(BuildContext context, int i) =>
      Navigator.pushReplacementNamed(context, kRouteMain, arguments: i);

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final tt = Theme.of(context).textTheme;
    final profile = profileProvider.profile;
    final name = profile.name.isNotEmpty ? profile.name : 'Developer';

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
          slivers: [
            // ── Vibrant Header ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: tt.titleMedium?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    name,
                                    style: tt.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white24,
                              child: Text(
                                name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Overlapping Stat Cards
                  Positioned(
                    top: 140,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            label: 'Projects',
                            value: '${projectProvider.totalProjects}',
                            icon: Icons.folder_copy_rounded,
                            color: AppTheme.info,
                            onTap: () => _goToTab(context, 1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MetricCard(
                            label: 'Completed',
                            value: '${projectProvider.completedProjects}',
                            icon: Icons.check_circle_rounded,
                            color: AppTheme.success,
                            onTap: () => _goToTab(context, 1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MetricCard(
                            label: 'Skills',
                            value: '${skillProvider.totalSkills}',
                            icon: Icons.psychology_rounded,
                            color: AppTheme.secondary,
                            onTap: () => _goToTab(context, 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 80)), // Spacing for overlapping cards

            // ── Recent Projects ───────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Projects',
                          style: tt.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _goToTab(context, 1),
                          child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (projectProvider.recentProjects.isEmpty)
                      EmptyState(
                        icon: Icons.folder_outlined,
                        title: 'No Projects Yet',
                        message: 'Start tracking your work.',
                        actionLabel: 'Add Project',
                        onAction: () => Navigator.pushNamed(context, kRouteAddProject),
                      )
                    else
                      ...projectProvider.recentProjects.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProjectCard(project: p),
                          )),

                    const SizedBox(height: 24),

                    // ── Top Skills ────────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Skills',
                          style: tt.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _goToTab(context, 2),
                          child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (skillProvider.topSkills.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No skills added yet.',
                            style: tt.bodyMedium?.copyWith(color: AppTheme.textLight),
                          ),
                        ),
                      )
                    else
                      ...skillProvider.topSkills.map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SkillCard(skill: s),
                          )),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
