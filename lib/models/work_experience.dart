import 'package:uuid/uuid.dart';

class WorkExperience {
  WorkExperience({
    String? id,
    this.jobTitle = '',
    this.company = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
    this.current = false,
    this.bullets = const <String>[],
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final bool current;
  final List<String> bullets;

  WorkExperience copyWith({
    String? jobTitle,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    bool? current,
    List<String>? bullets,
  }) {
    return WorkExperience(
      id: id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      current: current ?? this.current,
      bullets: bullets ?? this.bullets,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'jobTitle': jobTitle,
        'company': company,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
        'current': current,
        'bullets': bullets,
      };

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
        id: json['id'] as String?,
        jobTitle: (json['jobTitle'] as String?) ?? '',
        company: (json['company'] as String?) ?? '',
        location: (json['location'] as String?) ?? '',
        startDate: (json['startDate'] as String?) ?? '',
        endDate: (json['endDate'] as String?) ?? '',
        current: (json['current'] as bool?) ?? false,
        bullets: ((json['bullets'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) => e.toString())
            .toList(),
      );
}
