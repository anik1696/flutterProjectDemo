import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';

/// Profile setup screen used both for first-time onboarding and for editing
/// an existing profile. When [isEditing] is true, it pre-fills the form with
/// the current profile data and navigates back after saving.
class OnboardingScreen extends StatefulWidget {
  final bool isEditing;

  const OnboardingScreen({super.key, this.isEditing = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  late final TextEditingController _githubUsernameController;
  late final TextEditingController _githubUrlController;
  late final TextEditingController _websiteUrlController;

  bool _isLoading = false;

  bool get _isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing profile if editing
    final profile = context.read<ProfileProvider>().profile;
    _nameController =
        TextEditingController(text: _isEditing ? profile.name : '');
    _titleController =
        TextEditingController(text: _isEditing ? profile.title : '');
    _bioController =
        TextEditingController(text: _isEditing ? profile.bio : '');
    _emailController =
        TextEditingController(text: _isEditing ? profile.email : '');
    _githubUsernameController =
        TextEditingController(text: _isEditing ? profile.githubUsername : '');
    _githubUrlController =
        TextEditingController(text: _isEditing ? profile.githubUrl : '');
    _websiteUrlController =
        TextEditingController(text: _isEditing ? profile.websiteUrl : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _githubUsernameController.dispose();
    _githubUrlController.dispose();
    _websiteUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final profile = UserProfile(
      name: _nameController.text.trim(),
      title: _titleController.text.trim(),
      bio: _bioController.text.trim(),
      email: _emailController.text.trim(),
      githubUsername: _githubUsernameController.text.trim(),
      githubUrl: _githubUrlController.text.trim(),
      websiteUrl: _websiteUrlController.text.trim(),
      isProfileComplete: true,
    );

    await context.read<ProfileProvider>().saveProfile(profile);

    if (mounted) {
      setState(() => _isLoading = false);
      if (_isEditing) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
      } else {
        Navigator.pushReplacementNamed(context, kRouteMain);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Show AppBar with back button when editing an existing profile
      appBar: _isEditing
          ? AppBar(
              title: const Text('Edit Profile'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: _isEditing ? 24 : 48),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.code_rounded,
                      size: 48,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isEditing ? 'Edit Your Profile' : 'Create Your Profile',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isEditing
                      ? 'Update your developer profile details below.'
                      : 'Set up your developer profile to get started.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: 'Full Name *',
                        controller: _nameController,
                        validator: Validators.validateName,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Professional Title *',
                        hint: 'e.g. Flutter Developer',
                        controller: _titleController,
                        validator: (v) =>
                            Validators.validateRequired(v, 'Professional title'),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Short Bio *',
                        controller: _bioController,
                        validator: Validators.validateBio,
                        maxLines: 4,
                        minLines: 3,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Email Address *',
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'GitHub Username',
                        hint: 'your-username',
                        controller: _githubUsernameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'GitHub Profile URL',
                        hint: 'https://github.com/username',
                        controller: _githubUrlController,
                        validator: (v) => Validators.validateUrl(
                          v,
                          required: false,
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Portfolio / Website URL',
                        hint: 'https://yourwebsite.com',
                        controller: _websiteUrlController,
                        validator: (v) => Validators.validateUrl(
                          v,
                          required: false,
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditing ? 'Save Changes' : 'Create Profile'),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
