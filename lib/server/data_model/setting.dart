import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
class Setting {
  Id id = Isar.autoIncrement;

  @Index(unique: true, type: IndexType.value)
  String key;

  String value;

  Setting({
    required this.key,
    required this.value,
  });
}
