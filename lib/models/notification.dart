class NotificationModel {
  final String title;

  const NotificationModel({
    required this.title,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['subject']["title"],
    );
  }
}
