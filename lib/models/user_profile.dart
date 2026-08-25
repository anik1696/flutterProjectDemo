/// Represents the authenticated user's public portfolio profile.
class UserProfile {
  final String name;
  final String title;
  final String bio;
  final String email;
  final String githubUsername;
  final String githubUrl;
  final String websiteUrl;
  final bool isProfileComplete;

  const UserProfile({
    this.name = '',
    this.title = '',
    this.bio = '',
    this.email = '',
    this.githubUsername = '',
    this.githubUrl = '',
    this.websiteUrl = '',
    this.isProfileComplete = false,
  });

  /// Creates a [UserProfile] from a JSON map.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      email: json['email'] as String? ?? '',
      githubUsername: json['githubUsername'] as String? ?? '',
      githubUrl: json['githubUrl'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    );
  }

  /// Serialises this [UserProfile] to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'bio': bio,
      'email': email,
      'githubUsername': githubUsername,
      'githubUrl': githubUrl,
      'websiteUrl': websiteUrl,
      'isProfileComplete': isProfileComplete,
    };
  }

  /// Returns a copy of this [UserProfile] with the given fields replaced.
  UserProfile copyWith({
    String? name,
    String? title,
    String? bio,
    String? email,
    String? githubUsername,
    String? githubUrl,
    String? websiteUrl,
    bool? isProfileComplete,
  }) {
    return UserProfile(
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      githubUsername: githubUsername ?? this.githubUsername,
      githubUrl: githubUrl ?? this.githubUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  /// Returns `true` when the profile has not yet been filled in (name is empty).
  bool get isEmpty => name.isEmpty;

  /// Returns `true` when the profile has at least a name set.
  bool get isNotEmpty => name.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => Object.hash(name, email);

  @override
  String toString() =>
      'UserProfile(name: $name, title: $title, email: $email)';
}
