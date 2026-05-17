import 'package:uuid/uuid.dart';

class EducationEntry {
  EducationEntry({
    String? id,
    this.degree = '',
    this.institution = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.gradeOrGpa = '',
    this.details = '',
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String degree;
  final String institution;
  final String location;
  final String startDate;
  final String endDate;
  final String gradeOrGpa;
  final String details;

  EducationEntry copyWith({
    String? degree,
    String? institution,
    String? location,
    String? startDate,
    String? endDate,
    String? gradeOrGpa,
    String? details,
  }) {
    return EducationEntry(
      id: id,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gradeOrGpa: gradeOrGpa ?? this.gradeOrGpa,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'degree': degree,
        'institution': institution,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
        'gradeOrGpa': gradeOrGpa,
        'details': details,
      };

  factory EducationEntry.fromJson(Map<String, dynamic> json) => EducationEntry(
        id: json['id'] as String?,
        degree: (json['degree'] as String?) ?? '',
        institution: (json['institution'] as String?) ?? '',
        location: (json['location'] as String?) ?? '',
        startDate: (json['startDate'] as String?) ?? '',
        endDate: (json['endDate'] as String?) ?? '',
        gradeOrGpa: (json['gradeOrGpa'] as String?) ?? '',
        details: (json['details'] as String?) ?? '',
      );
}
