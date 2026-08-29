import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';

class ProfileStore {
  Profile _profile = const Profile();
  Profile get profile => _profile;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('gongfit_profile');
    if (raw == null) return;
    final m = jsonDecode(raw) as Map<String, dynamic>;
    _profile = Profile(targetJob: m['targetJob'] ?? '', major: m['major'] ?? '', certifications: m['certifications'] ?? '', experience: m['experience'] ?? '');
  }

  Future<void> update({String? targetJob, String? major, String? certifications, String? experience}) async {
    _profile = Profile(targetJob: targetJob ?? _profile.targetJob, major: major ?? _profile.major, certifications: certifications ?? _profile.certifications, experience: experience ?? _profile.experience);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gongfit_profile', jsonEncode({'targetJob':_profile.targetJob,'major':_profile.major,'certifications':_profile.certifications,'experience':_profile.experience}));
  }
}
final profileStore = ProfileStore();
