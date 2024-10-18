import 'dart:convert';

import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
class Setting {
  Id id;

  @Index(unique: true, type: IndexType.value)
  String key;

  String value;

  Setting({
    this.id = Isar.autoIncrement,
    required this.key,
    required this.value,
  });

  factory Setting.create({
    int id = Isar.autoIncrement,
    required String key,
    required String value,
  }) {
    return Setting(
      id: id,
      key: key,
      value: value,
    );
  }

  Setting update({
    String? key,
    String? value,
  }) {
    this.key = key ?? this.key;
    this.value = value ?? this.value;
    return this;
  }

  Setting copyWith({
    String? key,
    String? value,
  }) {
    return Setting(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      id: map['id'] ?? Isar.autoIncrement,
      key: map['key'] as String,
      value: map['value'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'value': value,
    };
  }

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
