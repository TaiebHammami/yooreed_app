class Secteur {
  final int id;

  final String nom;

  final String image;
  bool isSelected = false ;

  Secteur({required this.id, required this.nom, required this.image});

  factory Secteur.fromJson(Map<String, dynamic> json) {
    return Secteur(id: json['id'], nom: json['nom'], image: json['image']);
  }
}
