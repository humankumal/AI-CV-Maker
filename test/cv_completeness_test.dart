import 'package:ai_cv_maker/models/cv_document.dart';
import 'package:ai_cv_maker/models/education_entry.dart';
import 'package:ai_cv_maker/models/skill_item.dart';
import 'package:ai_cv_maker/models/template_config.dart';
import 'package:ai_cv_maker/models/user_profile.dart';
import 'package:ai_cv_maker/models/work_experience.dart';
import 'package:ai_cv_maker/services/cv_completeness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CvDocument doc({
    UserProfile profile = const UserProfile(),
    List<WorkExperience> experience = const <WorkExperience>[],
    List<EducationEntry> education = const <EducationEntry>[],
    List<SkillItem> skills = const <SkillItem>[],
  }) {
    return CvDocument(
      countryCode: 'GB',
      templateId: 'GB-01',
      profile: profile,
      experience: experience,
      education: education,
      skills: skills,
    );
  }

  test('empty CV scores 0', () {
    expect(CvCompleteness.overall(doc()), 0);
  });

  test('basics scores by filled required fields', () {
    final CvDocument d = doc(
      profile: const UserProfile(
        fullName: 'A',
        email: 'a@b.co',
        phone: '+1',
        location: 'X',
      ),
    );
    expect(CvCompleteness.basicsScore(d), 1.0);
  });

  test('experience without bullets is partial', () {
    final CvDocument d = doc(experience: <WorkExperience>[
      WorkExperience(jobTitle: 'Eng', company: 'Acme'),
    ]);
    expect(CvCompleteness.scoreFor(CvSectionKind.experience, d), 0.4);
  });

  test('experience with bullets is full', () {
    final CvDocument d = doc(experience: <WorkExperience>[
      WorkExperience(
        jobTitle: 'Eng',
        company: 'Acme',
        bullets: <String>['Shipped X'],
      ),
    ]);
    expect(CvCompleteness.scoreFor(CvSectionKind.experience, d), 1.0);
  });

  test('skills under 4 is half', () {
    final CvDocument d = doc(skills: <SkillItem>[
      SkillItem(name: 'A'),
      SkillItem(name: 'B'),
    ]);
    expect(CvCompleteness.scoreFor(CvSectionKind.skills, d), 0.5);
  });
}
