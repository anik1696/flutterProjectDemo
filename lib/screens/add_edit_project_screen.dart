import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/tech_chip.dart';

class AddEditProjectScreen extends StatefulWidget {
  final Project? project;

  const AddEditProjectScreen({super.key, this.project});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _githubUrlController;
  late final TextEditingController _liveDemoUrlController;
  late final TextEditingController _milestoneController;
  late final TextEditingController _architectureController;
  late final TextEditingController _featureNotesController;
  late final TextEditingController _techInputController;

  String _selectedCategory = kProjectCategories[0];
  String _selectedStatus = kStatusInProgress;
  DateTime? _startDate;
  DateTime? _targetDate;
  List<String> _technologies = [];
  bool _isLoading = false;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _githubUrlController = TextEditingController(text: p?.githubUrl ?? '');
    _liveDemoUrlController = TextEditingController(text: p?.liveDemoUrl ?? '');
    _milestoneController = TextEditingController(text: p?.milestone ?? '');
    _architectureController =
        TextEditingController(text: p?.architectureNotes ?? '');
    _featureNotesController =
        TextEditingController(text: p?.featureNotes ?? '');
    _techInputController = TextEditingController();

    if (p != null) {
      _selectedCategory = p.category;
      _selectedStatus = p.status;
      _startDate = p.startDate;
      _targetDate = p.targetDate;
      _technologies = List<String>.from(p.technologies);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _githubUrlController.dispose();
    _liveDemoUrlController.dispose();
    _milestoneController.dispose();
    _architectureController.dispose();
    _featureNotesController.dispose();
    _techInputController.dispose();
    super.dispose();
  }

  void _addTechnology() {
    final tech = _techInputController.text.trim();
    if (tech.isEmpty) return;
    if (_technologies.contains(tech)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already added')),
      );
      return;
    }
    setState(() {
      _technologies.add(tech);
      _techInputController.clear();
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_technologies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one technology')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final project = Project(
      id: _isEditing ? widget.project!.id : Project.generateId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      githubUrl: _githubUrlController.text.trim(),
      liveDemoUrl: _liveDemoUrlController.text.trim(),
      technologies: _technologies,
      status: _selectedStatus,
      startDate: _startDate,
      targetDate: _targetDate,
      milestone: _milestoneController.text.trim(),
      architectureNotes: _architectureController.text.trim(),
      featureNotes: _featureNotesController.text.trim(),
      createdAt: _isEditing ? widget.project!.createdAt : DateTime.now(),
    );

    if (_isEditing) {
      await context.read<ProjectProvider>().updateProject(project);
    } else {
      await context.read<ProjectProvider>().addProject(project);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Project updated successfully.'
                : 'Project added successfully.',
          ),
        ),
      );
    }
  }

  Widget _buildSectionLabel(String label) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    void Function(DateTime) onPicked,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value != null
                        ? DateFormat('MMM d, yyyy').format(value)
                        : 'Not set',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (value != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    if (label.contains('Start')) {
                      _startDate = null;
                    } else {
                      _targetDate = null;
                    }
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Project' : 'Add Project'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Basic Information ──────────────────────────────────────
              _buildSectionLabel('Basic Information'),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Project Title *',
                controller: _titleController,
                validator: Validators.validateTitle,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description *',
                controller: _descriptionController,
                validator: Validators.validateDescription,
                maxLines: 5,
                minLines: 3,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: kProjectCategories
                    .map(
                      (c) => DropdownMenuItem(value: c, child: Text(c)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 24),

              // ── Links ──────────────────────────────────────────────────
              _buildSectionLabel('Links (Optional)'),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'GitHub Repository URL',
                hint: 'https://github.com/...',
                controller: _githubUrlController,
                validator: (v) => Validators.validateUrl(v, required: false),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Live Demo URL',
                hint: 'https://...',
                controller: _liveDemoUrlController,
                validator: (v) => Validators.validateUrl(v, required: false),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // ── Technology Stack ───────────────────────────────────────
              _buildSectionLabel('Technology Stack *'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Add technology',
                      controller: _techInputController,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _addTechnology(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FilledButton.tonal(
                      onPressed: _addTechnology,
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_technologies.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _technologies
                      .map(
                        (tech) => TechChip(
                          label: tech,
                          showClose: true,
                          onClose: () =>
                              setState(() => _technologies.remove(tech)),
                        ),
                      )
                      .toList(),
                ),
              if (_technologies.isEmpty)
                Text(
                  'Add at least one technology',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.error,
                  ),
                ),
              const SizedBox(height: 24),

              // ── Status & Timeline ──────────────────────────────────────
              _buildSectionLabel('Status & Timeline'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kProjectStatuses
                    .map(
                      (s) => ChoiceChip(
                        label: Text(s),
                        selected: _selectedStatus == s,
                        onSelected: (_) =>
                            setState(() => _selectedStatus = s),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      'Start Date',
                      _startDate,
                      (d) => setState(() => _startDate = d),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateField(
                      'Target Date',
                      _targetDate,
                      (d) => setState(() => _targetDate = d),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Milestone',
                hint: 'e.g. MVP launched',
                controller: _milestoneController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),

              // ── Technical Details ──────────────────────────────────────
              _buildSectionLabel('Technical Details (Optional)'),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Architecture / Technical Notes',
                controller: _architectureController,
                maxLines: 4,
                minLines: 2,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Feature Notes',
                controller: _featureNotesController,
                maxLines: 4,
                minLines: 2,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),

              // ── Submit ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEditing ? 'Save Changes' : 'Add Project',
                        ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
