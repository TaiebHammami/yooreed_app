class Gouvernerat {
  final int id;
  final String name;

  Gouvernerat({required this.id, required this.name});

  factory Gouvernerat.fromJson(Map<String, dynamic?> json) {
    return Gouvernerat(id: json['id'], name: json['nom']);
  }
}
