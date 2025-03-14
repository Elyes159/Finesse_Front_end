class NotificationModel {
  final String title;
  final String body;
  final String image;
  final bool isRead;
  final DateTime createdAt;
  final int notifier_id;

  NotificationModel({
    required this.title,
    required this.body,
    required this.image,
    required this.isRead,
    required this.createdAt,
    required this.notifier_id,
  });

  // Factory constructor pour convertir le JSON en objet
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      image: json['image'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      notifier_id: json['notifier_id'],
    );
  }
}
