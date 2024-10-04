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
    required String key,
    required String value,
  }) {
    return Setting(
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
}
