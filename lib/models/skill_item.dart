import 'package:uuid/uuid.dart';

class SkillItem {
  SkillItem({
    String? id,
    this.name = '',
    this.level = SkillLevel.proficient,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final SkillLevel level;

  SkillItem copyWith({String? name, SkillLevel? level}) => SkillItem(
        id: id,
        name: name ?? this.name,
        level: level ?? this.level,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'level': level.name,
      };

  factory SkillItem.fromJson(Map<String, dynamic> json) => SkillItem(
        id: json['id'] as String?,
        name: (json['name'] as String?) ?? '',
        level: SkillLevel.values.firstWhere(
          (SkillLevel e) => e.name == json['level'],
          orElse: () => SkillLevel.proficient,
        ),
      );
}

enum SkillLevel { beginner, intermediate, proficient, advanced, expert }
