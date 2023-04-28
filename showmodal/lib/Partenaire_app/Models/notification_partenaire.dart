class NotificationModelPartenaire {
  final int id;

  final String title;
  final String image;
  final String date;
  final String status;

  NotificationModelPartenaire({
    required this.id,
    required this.title,
    required this.image,
    required this.status,
    required this.date,
  });

  factory NotificationModelPartenaire.fromJson(Map<String, dynamic?> json) {
    return NotificationModelPartenaire(
      title: json['title'],
      image: json['image'],
      date: json['date'],
      status: json['status'],
      id: json['id'],
    );
  }
}
