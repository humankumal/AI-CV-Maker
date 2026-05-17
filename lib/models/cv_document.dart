import 'package:uuid/uuid.dart';

import 'certification_item.dart';
import 'education_entry.dart';
import 'language_item.dart';
import 'project_item.dart';
import 'skill_item.dart';
import 'user_profile.dart';
import 'work_experience.dart';

class CvDocument {
  CvDocument({
    String? id,
    this.name = 'Untitled CV',
    required this.countryCode,
    required this.templateId,
    this.profile = const UserProfile(),
    this.experience = const <WorkExperience>[],
    this.education = const <EducationEntry>[],
    this.skills = const <SkillItem>[],
    this.projects = const <ProjectItem>[],
    this.certifications = const <CertificationItem>[],
    this.languages = const <LanguageItem>[],
    this.references = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final String name;
  final String countryCode;
  final String templateId;
  final UserProfile profile;
  final List<WorkExperience> experience;
  final List<EducationEntry> education;
  final List<SkillItem> skills;
  final List<ProjectItem> projects;
  final List<CertificationItem> certifications;
  final List<LanguageItem> languages;
  final String references;
  final DateTime createdAt;
  final DateTime updatedAt;

  CvDocument copyWith({
    String? name,
    String? countryCode,
    String? templateId,
    UserProfile? profile,
    List<WorkExperience>? experience,
    List<EducationEntry>? education,
    List<SkillItem>? skills,
    List<ProjectItem>? projects,
    List<CertificationItem>? certifications,
    List<LanguageItem>? languages,
    String? references,
    DateTime? updatedAt,
  }) {
    return CvDocument(
      id: id,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      templateId: templateId ?? this.templateId,
      profile: profile ?? this.profile,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      references: references ?? this.references,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'countryCode': countryCode,
        'templateId': templateId,
        'profile': profile.toJson(),
        'experience':
            experience.map((WorkExperience e) => e.toJson()).toList(),
        'education':
            education.map((EducationEntry e) => e.toJson()).toList(),
        'skills': skills.map((SkillItem e) => e.toJson()).toList(),
        'projects': projects.map((ProjectItem e) => e.toJson()).toList(),
        'certifications':
            certifications.map((CertificationItem e) => e.toJson()).toList(),
        'languages':
            languages.map((LanguageItem e) => e.toJson()).toList(),
        'references': references,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CvDocument.fromJson(Map<String, dynamic> json) => CvDocument(
        id: json['id'] as String?,
        name: (json['name'] as String?) ?? 'Untitled CV',
        countryCode: json['countryCode'] as String,
        templateId: json['templateId'] as String,
        profile: UserProfile.fromJson(
            (json['profile'] as Map<String, dynamic>?) ?? <String, dynamic>{}),
        experience: ((json['experience'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) =>
                WorkExperience.fromJson(e as Map<String, dynamic>))
            .toList(),
        education: ((json['education'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) =>
                EducationEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        skills: ((json['skills'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) => SkillItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        projects: ((json['projects'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) =>
                ProjectItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        certifications:
            ((json['certifications'] as List<dynamic>?) ?? <dynamic>[])
                .map((dynamic e) =>
                    CertificationItem.fromJson(e as Map<String, dynamic>))
                .toList(),
        languages: ((json['languages'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) =>
                LanguageItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        references: (json['references'] as String?) ?? '',
        createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '') ??
            DateTime.now(),
      );
}
