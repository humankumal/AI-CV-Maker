import 'package:ai_cv_maker/models/cv_document.dart';
import 'package:ai_cv_maker/models/education_entry.dart';
import 'package:ai_cv_maker/models/skill_item.dart';
import 'package:ai_cv_maker/models/user_profile.dart';
import 'package:ai_cv_maker/models/work_experience.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CvDocument JSON round-trip preserves all fields', () {
    final CvDocument original = CvDocument(
      name: 'My CV',
      countryCode: 'GB',
      templateId: 'GB-01',
      profile: const UserProfile(
        fullName: 'Alex Morgan',
        email: 'a@example.com',
        summary: 'A summary.',
      ),
      experience: <WorkExperience>[
        WorkExperience(
          jobTitle: 'Engineer',
          company: 'Acme',
          startDate: '2020',
          current: true,
          bullets: <String>['Shipped X', 'Improved Y'],
        ),
      ],
      education: <EducationEntry>[
        EducationEntry(
          degree: 'BSc',
          institution: 'University',
          startDate: '2017',
          endDate: '2020',
        ),
      ],
      skills: <SkillItem>[SkillItem(name: 'Dart')],
    );

    final Map<String, dynamic> json = original.toJson();
    final CvDocument restored = CvDocument.fromJson(json);

    expect(restored.id, original.id);
    expect(restored.name, original.name);
    expect(restored.countryCode, 'GB');
    expect(restored.templateId, 'GB-01');
    expect(restored.profile.fullName, 'Alex Morgan');
    expect(restored.experience.length, 1);
    expect(restored.experience.first.bullets, <String>['Shipped X', 'Improved Y']);
    expect(restored.education.first.degree, 'BSc');
    expect(restored.skills.first.name, 'Dart');
  });
}
