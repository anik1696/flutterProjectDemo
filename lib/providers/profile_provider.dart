import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile _profile = const UserProfile();
  bool _isProfileSetup = false;

  UserProfile get profile => _profile;
  bool get isProfileSetup => _isProfileSetup;
  bool get hasProfile => _isProfileSetup && !_profile.isEmpty;

  Future<void> loadProfile() async {
    _isProfileSetup = LocalStorageService().isProfileSetup();
    final stored = LocalStorageService().loadProfile();
    if (stored != null) {
      _profile = stored;
    }
    notifyListeners();
  }

  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
    _isProfileSetup = true;
    await LocalStorageService().saveProfile(profile);
    await LocalStorageService().setProfileSetup(true);
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    _profile = profile;
    await LocalStorageService().saveProfile(profile);
    notifyListeners();
  }

  Future<void> clearProfile() async {
    _profile = const UserProfile();
    _isProfileSetup = false;
    notifyListeners();
  }
}
