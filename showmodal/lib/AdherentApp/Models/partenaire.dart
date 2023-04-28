class Partenaire {
  final int id;
  final String nom_responsable;
  final String prenom;
  final String specialite;
  final String profession;
  final String ville;
  final String gouvernerat;
  final String email;
  final String image;
  final int cin;
  final int numero;
  final String adresse;

  Partenaire({
    required this.id,
    required this.nom_responsable,
    required this.specialite,
    required this.profession,
    required this.ville,
    required this.gouvernerat,
    required this.prenom,
    required this.email,
    required this.image,
    required this.cin,
    required this.numero,
    required this.adresse,
  });

  factory Partenaire.fromJson(Map<String, dynamic> json) {
    return Partenaire(
        id: json['id'],
        nom_responsable: json['nom_responsable'],
        prenom: json['prenom'],

        email: json['email'],
        image: json['image'],
        cin: json['cin'],
        numero: json['numero'],
        adresse: json['adresse'], specialite: json['specialite'], profession: json['profession'],ville: json['ville'],gouvernerat: json['gouvernerat']);
  }
}
