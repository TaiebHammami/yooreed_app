class NotificationModel {
  final String title;
  final String description;
  final String date;
  final String created_at;

  NotificationModel(
      {required this.title,
      required this.description,
      required this.date,
      required this.created_at});

  factory NotificationModel.fromJson(Map<String, dynamic?> json) {
    return NotificationModel(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      created_at: json['created_at'],

    );
  }
}
