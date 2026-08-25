/// A collection of static form-field validators used across CodeFolio Pro.
///
/// Every method follows the Flutter [FormFieldValidator] convention:
/// returns `null` when the value is valid, or a human-readable error
/// string when it is not.
class Validators {
  // Private constructor — this class is not meant to be instantiated.
  Validators._();

  // ---------------------------------------------------------------------------
  // Primitive validators
  // ---------------------------------------------------------------------------

  /// Returns an error if [value] is null or blank.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Returns an error if [value] is not a valid e-mail address.
  static String? validateEmail(String? value) {
    final required = validateRequired(value, 'Email');
    if (required != null) return required;

    const pattern =
        r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Returns an error if [value] is not a valid URL (must start with
  /// `http://` or `https://`). When [required] is `false` an empty value
  /// is accepted.
  static String? validateUrl(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return required ? 'URL is required.' : null;
    }

    const pattern = r'^https?://[^\s/$.?#].[^\s]*$';
    final regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(trimmed)) {
      return 'Please enter a valid URL starting with http:// or https://.';
    }
    return null;
  }

  /// Returns an error if [value] is shorter than [min] characters.
  static String? validateMinLength(
    String? value,
    int min,
    String fieldName,
  ) {
    final required = validateRequired(value, fieldName);
    if (required != null) return required;

    if (value!.trim().length < min) {
      return '$fieldName must be at least $min characters long.';
    }
    return null;
  }

  /// Returns an error if [value] exceeds [max] characters.
  static String? validateMaxLength(
    String? value,
    int max,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > max) {
      return '$fieldName must not exceed $max characters.';
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Domain-specific validators
  // ---------------------------------------------------------------------------

  /// Validates a user display name (required, 2–100 chars).
  static String? validateName(String? value) {
    final minErr = validateMinLength(value, 2, 'Name');
    if (minErr != null) return minErr;
    return validateMaxLength(value, 100, 'Name');
  }

  /// Validates a profile bio (required, 20–500 chars).
  static String? validateBio(String? value) {
    final minErr = validateMinLength(value, 20, 'Bio');
    if (minErr != null) return minErr;
    return validateMaxLength(value, 500, 'Bio');
  }

  /// Validates a project/skill title (required, 3–150 chars).
  static String? validateTitle(String? value) {
    final minErr = validateMinLength(value, 3, 'Title');
    if (minErr != null) return minErr;
    return validateMaxLength(value, 150, 'Title');
  }

  /// Validates a project description (required, 10–2000 chars).
  static String? validateDescription(String? value) {
    final minErr = validateMinLength(value, 10, 'Description');
    if (minErr != null) return minErr;
    return validateMaxLength(value, 2000, 'Description');
  }

  /// Validates a GitHub repository URL.
  ///
  /// When [required] is `false` an empty value is accepted. When a value is
  /// provided it must be a valid URL that contains `github.com`.
  static String? validateGithubUrl(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return required ? 'GitHub URL is required.' : null;
    }

    final urlErr = validateUrl(trimmed);
    if (urlErr != null) return urlErr;

    if (!trimmed.toLowerCase().contains('github.com')) {
      return 'Please enter a valid GitHub URL (must contain github.com).';
    }
    return null;
  }
}
