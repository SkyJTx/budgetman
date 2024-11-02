// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationPayload {
  final String? action;
  final String path;
  final Object? extra;

  const NotificationPayload({
    this.action,
    required this.path,
    this.extra,
  });

  NotificationPayload copyWith({
    String? action,
    String? path,
    Object? extra,
  }) {
    return NotificationPayload(
      action: action ?? this.action,
      path: path ?? this.path,
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'action': action,
      'path': path,
      'extra': extra,
    };
  }

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      action: map['action'] != null ? map['action'] as String : null,
      path: map['path'] as String,
      extra: map['extra'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationPayload.fromJson(String source) => NotificationPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationPayload(action: $action, path: $path, extra: $extra)';

  @override
  bool operator ==(covariant NotificationPayload other) {
    if (identical(this, other)) return true;
  
    return 
      other.action == action &&
      other.path == path &&
      other.extra == extra;
  }

  @override
  int get hashCode => action.hashCode ^ path.hashCode ^ extra.hashCode;
}
