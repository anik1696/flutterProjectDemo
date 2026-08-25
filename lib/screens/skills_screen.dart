import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/skill_provider.dart';
import '../models/skill.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/skill_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';
import '../app/theme.dart';

/// Skills management screen. Shows skills grouped by category with
/// add / edit / delete capabilities via a modal bottom sheet.
class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  void _showSkillDialog(BuildContext context, {Skill? skill}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SkillFormSheet(skill: skill),
    );
  }

  void _confirmDelete(BuildContext context, Skill skill) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Skill?'),
        content: Text('Remove "${skill.name}" from your skills?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<SkillProvider>().deleteSkill(skill.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Skill deleted.')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, _) {
        final grouped = provider.skillsByCategory;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Skills'),
            actions: [
              if (provider.totalSkills > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Chip(
                    label: Text('${provider.totalSkills} skills'),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
          body: provider.skills.isEmpty
              ? EmptyState(
                  icon: Icons.psychology_outlined,
                  title: 'No Skills Yet',
                  message:
                      'Add your technical skills to showcase your expertise.',
                  actionLabel: 'Add Skill',
                  onAction: () => _showSkillDialog(context),
                )
              : CustomScrollView(
                  slivers: [
                    // Average proficiency header card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: _AvgProficiencyCard(
                          avgProficiency: provider.averageProficiency,
                        ),
                      ),
                    ),

                    // Skills grouped by category
                    for (final entry in grouped.entries) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: SectionHeader(title: entry.key),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final s = entry.value[i];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: SkillCard(
                                skill: s,
                                onEdit: () =>
                                    _showSkillDialog(context, skill: s),
                                onDelete: () => _confirmDelete(context, s),
                              ),
                            );
                          },
                          childCount: entry.value.length,
                        ),
                      ),
                    ],

                    // Bottom space for FAB
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
          floatingActionButton: provider.skills.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showSkillDialog(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Skill'),
                ),
        );
      },
    );
  }
}

// ── Average proficiency card ─────────────────────────────────────────────────

class _AvgProficiencyCard extends StatelessWidget {
  final double avgProficiency;

  const _AvgProficiencyCard({required this.avgProficiency});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pct = (avgProficiency * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.insights_rounded,
                  color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Average Proficiency',
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: avgProficiency,
                      minHeight: 8,
                      color: scheme.primary,
                      backgroundColor: scheme.primary.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$pct%',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skill form bottom sheet ──────────────────────────────────────────────────

class _SkillFormSheet extends StatefulWidget {
  final Skill? skill;

  const _SkillFormSheet({this.skill});

  @override
  State<_SkillFormSheet> createState() => _SkillFormSheetState();
}

class _SkillFormSheetState extends State<_SkillFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _yearsController;
  late final TextEditingController _notesController;

  String _selectedCategory = kSkillCategories[0];
  String _selectedProficiency = kProficiencyBeginner;
  bool _isSaving = false;

  bool get _isEditing => widget.skill != null;

  @override
  void initState() {
    super.initState();
    final s = widget.skill;
    _nameController = TextEditingController(text: s?.name ?? '');
    _yearsController = TextEditingController(
      text: s != null && s.yearsExperience > 0
          ? s.yearsExperience.toStringAsFixed(1)
          : '',
    );
    _notesController = TextEditingController(text: s?.notes ?? '');

    if (s != null) {
      _selectedCategory = s.category;
      _selectedProficiency = s.proficiency;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Check for duplicate name (excluding self when editing)
    final provider = context.read<SkillProvider>();
    if (provider.skillExists(_nameController.text.trim(),
        excludeId: widget.skill?.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A skill with this name already exists.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final yearsText = _yearsController.text.trim();
    final years = double.tryParse(yearsText) ?? 0.0;

    final skill = Skill(
      id: _isEditing ? widget.skill!.id : Skill.generateId(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      proficiency: _selectedProficiency,
      yearsExperience: years,
      notes: _notesController.text.trim(),
    );

    if (_isEditing) {
      await provider.updateSkill(skill);
    } else {
      await provider.addSkill(skill);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Skill updated.' : 'Skill added.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEditing ? 'Edit Skill' : 'Add Skill',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Skill name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Skill Name *',
                  hintText: 'e.g. Flutter, Python, SQL',
                ),
                validator: (v) => Validators.validateRequired(v, 'Skill name'),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: kSkillCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 20),

              // Proficiency
              Text(
                'Proficiency Level',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kProficiencyLevels.map((level) {
                  final isSelected = _selectedProficiency == level;
                  final color = AppTheme.proficiencyColor(level, scheme);
                  return ChoiceChip(
                    label: Text(level),
                    selected: isSelected,
                    selectedColor: color.withOpacity(0.2),
                    checkmarkColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? color : scheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedProficiency = level),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Years
              TextFormField(
                controller: _yearsController,
                decoration: const InputDecoration(
                  labelText: 'Years of Experience',
                  hintText: 'e.g. 1.5',
                  suffixText: 'yrs',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = double.tryParse(v.trim());
                  if (n == null || n < 0) {
                    return 'Enter a valid number (e.g. 1.5)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Any additional context…',
                ),
                maxLines: 3,
                minLines: 2,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 28),

              // Actions
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Update' : 'Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
