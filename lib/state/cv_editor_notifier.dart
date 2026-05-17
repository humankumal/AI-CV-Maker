import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/certification_item.dart';
import '../models/cv_document.dart';
import '../models/education_entry.dart';
import '../models/language_item.dart';
import '../models/project_item.dart';
import '../models/skill_item.dart';
import '../models/user_profile.dart';
import '../models/work_experience.dart';
import 'cv_list_notifier.dart';

/// Holds the CV currently being edited and auto-saves after a brief debounce.
class CvEditorNotifier extends ChangeNotifier {
  CvEditorNotifier(this._list);

  final CvListNotifier _list;
  CvDocument? _doc;
  Timer? _saveTimer;
  static const Duration _autosaveDelay = Duration(milliseconds: 500);

  CvDocument? get document => _doc;

  void open(CvDocument doc) {
    _doc = doc;
    notifyListeners();
  }

  void clear() {
    _saveTimer?.cancel();
    _doc = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  void _update(CvDocument next, {bool persist = true}) {
    _doc = next;
    notifyListeners();
    if (persist) _scheduleSave();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(_autosaveDelay, () async {
      final CvDocument? d = _doc;
      if (d == null) return;
      await _list.upsert(d);
    });
  }

  Future<void> saveNow() async {
    _saveTimer?.cancel();
    final CvDocument? d = _doc;
    if (d == null) return;
    await _list.upsert(d);
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------

  void setName(String name) => _update(_doc!.copyWith(name: name));
  void setTemplate(String templateId) =>
      _update(_doc!.copyWith(templateId: templateId));
  void setCountry(String code) => _update(_doc!.copyWith(countryCode: code));

  void setProfile(UserProfile p) => _update(_doc!.copyWith(profile: p));

  void addExperience() => _update(_doc!.copyWith(
      experience: <WorkExperience>[...?_doc?.experience, WorkExperience()]));
  void updateExperience(int i, WorkExperience e) {
    final List<WorkExperience> list = <WorkExperience>[...?_doc?.experience];
    list[i] = e;
    _update(_doc!.copyWith(experience: list));
  }

  void removeExperience(int i) {
    final List<WorkExperience> list = <WorkExperience>[...?_doc?.experience]
      ..removeAt(i);
    _update(_doc!.copyWith(experience: list));
  }

  void addEducation() => _update(_doc!.copyWith(
      education: <EducationEntry>[...?_doc?.education, EducationEntry()]));
  void updateEducation(int i, EducationEntry e) {
    final List<EducationEntry> list = <EducationEntry>[...?_doc?.education];
    list[i] = e;
    _update(_doc!.copyWith(education: list));
  }

  void removeEducation(int i) {
    final List<EducationEntry> list = <EducationEntry>[...?_doc?.education]
      ..removeAt(i);
    _update(_doc!.copyWith(education: list));
  }

  void addSkill(String name) {
    if (name.trim().isEmpty) return;
    _update(_doc!.copyWith(
        skills: <SkillItem>[...?_doc?.skills, SkillItem(name: name.trim())]));
  }

  void removeSkill(int i) {
    final List<SkillItem> list = <SkillItem>[...?_doc?.skills]..removeAt(i);
    _update(_doc!.copyWith(skills: list));
  }

  void addProject() => _update(_doc!.copyWith(
      projects: <ProjectItem>[...?_doc?.projects, ProjectItem()]));
  void updateProject(int i, ProjectItem p) {
    final List<ProjectItem> list = <ProjectItem>[...?_doc?.projects];
    list[i] = p;
    _update(_doc!.copyWith(projects: list));
  }

  void removeProject(int i) {
    final List<ProjectItem> list = <ProjectItem>[...?_doc?.projects]
      ..removeAt(i);
    _update(_doc!.copyWith(projects: list));
  }

  void addCertification() => _update(_doc!.copyWith(
      certifications: <CertificationItem>[
        ...?_doc?.certifications,
        CertificationItem(),
      ]));
  void updateCertification(int i, CertificationItem c) {
    final List<CertificationItem> list = <CertificationItem>[
      ...?_doc?.certifications,
    ];
    list[i] = c;
    _update(_doc!.copyWith(certifications: list));
  }

  void removeCertification(int i) {
    final List<CertificationItem> list = <CertificationItem>[
      ...?_doc?.certifications,
    ]..removeAt(i);
    _update(_doc!.copyWith(certifications: list));
  }

  void addLanguage(LanguageItem l) => _update(_doc!.copyWith(
      languages: <LanguageItem>[...?_doc?.languages, l]));
  void updateLanguage(int i, LanguageItem l) {
    final List<LanguageItem> list = <LanguageItem>[...?_doc?.languages];
    list[i] = l;
    _update(_doc!.copyWith(languages: list));
  }

  void removeLanguage(int i) {
    final List<LanguageItem> list = <LanguageItem>[...?_doc?.languages]
      ..removeAt(i);
    _update(_doc!.copyWith(languages: list));
  }

  void setReferences(String value) =>
      _update(_doc!.copyWith(references: value));
}
