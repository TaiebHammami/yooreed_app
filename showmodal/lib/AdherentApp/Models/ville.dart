class Ville {
  final int id;
  final String name;

  final int gouverneratId;

  Ville({required this.id, required this.name, required this.gouverneratId});

  factory Ville.fromJson(Map<String, dynamic?> json) {
    return Ville(
        id: json['id'],
        gouverneratId: json['gouvernerat_id'],
        name: json['nom']);
  }
}

