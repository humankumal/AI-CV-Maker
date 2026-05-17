import 'package:uuid/uuid.dart';

class ProjectItem {
  ProjectItem({
    String? id,
    this.name = '',
    this.role = '',
    this.url = '',
    this.startDate = '',
    this.endDate = '',
    this.description = '',
    this.bullets = const <String>[],
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final String role;
  final String url;
  final String startDate;
  final String endDate;
  final String description;
  final List<String> bullets;

  ProjectItem copyWith({
    String? name,
    String? role,
    String? url,
    String? startDate,
    String? endDate,
    String? description,
    List<String>? bullets,
  }) {
    return ProjectItem(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      url: url ?? this.url,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      bullets: bullets ?? this.bullets,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'role': role,
        'url': url,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
        'bullets': bullets,
      };

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
        id: json['id'] as String?,
        name: (json['name'] as String?) ?? '',
        role: (json['role'] as String?) ?? '',
        url: (json['url'] as String?) ?? '',
        startDate: (json['startDate'] as String?) ?? '',
        endDate: (json['endDate'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
        bullets: ((json['bullets'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) => e.toString())
            .toList(),
      );
}
