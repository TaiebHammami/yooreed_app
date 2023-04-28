class AuthResult {
  final int id;
  final String nom;
  final String prenom;
  final String role;
  final String email;
  final String image;
  final int cin;
  final int numero;
  final int firstTime;
  final String adresse;
  final String token;

  AuthResult(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.role,
      required this.email,
      required this.image,
      required this.cin,
      required this.numero,
      required this.firstTime,
      required this.adresse,
      required this.token});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
        id: json['data']['user']['userData']['id'],
        nom: json['data']['user']['userData']['nom'],
        prenom: json['data']['user']['userData']['prenom'],
        role: json['data']['user']['role'],
        email: json['data']['user']['userData']['email'],
        image: json['data']['user']['userData']['image'],
        cin: json['data']['user']['userData']['cin'],
        numero: json['data']['user']['userData']['numero'],
        firstTime: json['data']['user']['userData']['is_first_time'],
        adresse: json['data']['user']['userData']['adresse'],
        token: json['data']['token']);
  }
}

class User {
  final int? id;
  final String nom;
  final String prenom;

  final String email;
  final String image;
  final int cin;
  final int numero;
  final int firstTime;
  final String adresse;
   final String? responsable;

  User( {
    required this.id,
    required this.nom,
    required this.prenom,

    required this.email,
    required this.image,
    required this.cin,
    required this.numero,
    required this.firstTime,
    required this.adresse,
    required this.responsable,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        nom: json['nom'],
        prenom: json['prenom'],
        email: json['email'],
        image: json['image'],
        cin: json['cin'],
        numero: json['numero'],
        firstTime: json['is_first_time'],
        adresse: json['adresse'], responsable:  json['nom_responsable']);
  }
}
