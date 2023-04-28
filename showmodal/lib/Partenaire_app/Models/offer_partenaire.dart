class PartenaireOfferModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String dateDebut;
  final String dateFin;
  final String price;
  final int promo;
  final String status;

  PartenaireOfferModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.dateDebut,
      required this.dateFin,
      required this.price,
      required this.promo,
      required this.status});

  factory PartenaireOfferModel.fromJson(Map<String, dynamic?> json) {
    return PartenaireOfferModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      price: json['prix'],
      promo: json['promo'],
      image: json['image'],
      status: json['status'],
    );
  }
}
