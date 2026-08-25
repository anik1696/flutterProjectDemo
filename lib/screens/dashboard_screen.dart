import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final profile = profileProvider.profile;
    final name = profile.name.isNotEmpty ? profile.name : 'Developer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeFolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, kRouteSettings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            projectProvider.loadProjects(),
            skillProvider.loadSkills(),
            profileProvider.loadProfile(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ── Clean Header ──────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cs.primary.withValues(alpha: 0.1),
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $name',
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.title.isNotEmpty ? profile.title : 'Ready to build something?',
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Clean Stats Row ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    label: 'Projects',
                    value: '${projectProvider.totalProjects}',
                    onTap: () => _goToTab(context, 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    label: 'Completed',
                    value: '${projectProvider.completedProjects}',
                    onTap: () => _goToTab(context, 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    label: 'Skills',
                    value: '${skillProvider.totalSkills}',
                    onTap: () => _goToTab(context, 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Recent Projects ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Projects',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () => _goToTab(context, 1),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('View All'),
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProjectCard(project: p),
                  )),

            const SizedBox(height: 20),

            // ── Top Skills ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Skills',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () => _goToTab(context, 2),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('View All'),
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
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              )
            else
              ...skillProvider.topSkills.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SkillCard(skill: s),
                  )),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
