import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/constants.dart';
import '../app/theme.dart';
import '../widgets/project_card.dart';
import '../widgets/skill_card.dart';
import '../widgets/empty_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 🌅';
    if (hour < 17) return 'Good afternoon ☀️';
    return 'Good evening 👋';
  }

  String _dayLabel() {
    final now = DateTime.now();
    final days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  void _goToTab(BuildContext context, int i) =>
      Navigator.pushReplacementNamed(context, kRouteMain, arguments: i);

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final projectProvider = context.watch<ProjectProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final tt = Theme.of(context).textTheme;
    final name = profile.name.isNotEmpty ? profile.name : 'Developer';

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            projectProvider.loadProjects(),
            skillProvider.loadSkills(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: AppTheme.scaffoldBg,
              floating: true,
              snap: true,
              titleSpacing: 20,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    _dayLabel(),
                    style: tt.bodySmall?.copyWith(color: AppTheme.textSecond),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecond),
                      onPressed: () => Navigator.pushNamed(context, kRouteSettings),
                    ),
                  ),
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── 2×2 Metric Grid ───────────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _MetricTile(
                        label: 'Total Projects',
                        value: '${projectProvider.totalProjects}',
                        icon: Icons.folder_copy_rounded,
                        iconColor: AppTheme.info,
                        iconBg: AppTheme.iconBgBlue,
                      ),
                      _MetricTile(
                        label: 'In Progress',
                        value: '${projectProvider.inProgressProjects}',
                        icon: Icons.timelapse_rounded,
                        iconColor: AppTheme.warning,
                        iconBg: AppTheme.iconBgOrange,
                      ),
                      _MetricTile(
                        label: 'Completed',
                        value: '${projectProvider.completedProjects}',
                        icon: Icons.check_circle_rounded,
                        iconColor: AppTheme.success,
                        iconBg: AppTheme.iconBgGreen,
                      ),
                      _MetricTile(
                        label: 'Skills',
                        value: '${skillProvider.totalSkills}',
                        icon: Icons.psychology_rounded,
                        iconColor: AppTheme.purple,
                        iconBg: AppTheme.iconBgPurple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Recent Projects ───────────────────────────────────────
                  _SectionHeader(
                    title: 'Recent Projects',
                    onViewAll: () => _goToTab(context, 1),
                  ),
                  const SizedBox(height: 12),
                  if (projectProvider.recentProjects.isEmpty)
                    EmptyState(
                      icon: Icons.folder_outlined,
                      title: 'No Projects Yet',
                      message: 'Tap + to add your first project.',
                      actionLabel: 'Add Project',
                      onAction: () => Navigator.pushNamed(context, kRouteAddProject),
                    )
                  else
                    ...projectProvider.recentProjects.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ProjectCard(project: p),
                        )),

                  const SizedBox(height: 28),

                  // ── Top Skills ────────────────────────────────────────────
                  _SectionHeader(
                    title: 'Top Skills',
                    onViewAll: () => _goToTab(context, 2),
                  ),
                  const SizedBox(height: 12),
                  if (skillProvider.topSkills.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('No skills added yet.', style: tt.bodyMedium?.copyWith(color: AppTheme.textSecond)),
                      ),
                    )
                  else
                    Container(
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        children: [
                          for (int i = 0; i < skillProvider.topSkills.length; i++) ...[
                            SkillCard(skill: skillProvider.topSkills[i]),
                            if (i < skillProvider.topSkills.length - 1)
                              const Divider(height: 1, indent: 68),
                          ],
                        ],
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, kRouteAddProject),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Project', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// Reusable Section Header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  const _SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'View All',
              style: tt.labelMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// Metric Tile that matches the friend's app style
class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: tt.labelSmall?.copyWith(
                  color: AppTheme.textSecond,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: unused_element

