// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
class Setting {
  Id id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.value)
  String key;

  String value;

  Setting({
    required this.id,
    required this.key,
    required this.value,
  });

  Setting copyWith({
    Id? id,
    String? key,
    String? value,
  }) {
    return Setting(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'key': key,
      'value': value,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      id: map['id'] as Id,
      key: map['key'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Setting(id: $id, key: $key, value: $value)';

  @override
  bool operator ==(covariant Setting other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.key == key &&
      other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ key.hashCode ^ value.hashCode;
}
