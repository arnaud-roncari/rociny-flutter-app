class UserNotificationPreference {
  final String type;
  final bool enabled;

  UserNotificationPreference({
    required this.type,
    required this.enabled,
  });

  factory UserNotificationPreference.fromJson(Map<String, dynamic> json) {
    return UserNotificationPreference(
      type: json['type'] as String,
      enabled: json['enabled'] as bool,
    );
  }

  static List<UserNotificationPreference> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserNotificationPreference.fromJson(json)).toList();
  }
}
