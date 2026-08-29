import 'profile.dart';

class ProfileStore {
  Profile _profile = const Profile();
  Profile get profile => _profile;
  void update({String? targetJob, String? major, String? certifications, String? experience}) {
    _profile = Profile(
      targetJob: targetJob ?? _profile.targetJob,
      major: major ?? _profile.major,
      certifications: certifications ?? _profile.certifications,
      experience: experience ?? _profile.experience,
    );
  }
}

final profileStore = ProfileStore();
