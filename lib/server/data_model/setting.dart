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
}
