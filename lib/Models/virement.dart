class Virement {
  final int virementId;
  final String nomComplet;
  final String banque;
  final String iban;
  final String bicSwift;
  final String rib;
  final String pays;

  Virement({
    required this.virementId,
    required this.nomComplet,
    required this.banque,
    required this.iban,
    required this.bicSwift,
    required this.rib,
    required this.pays,
  });

  // Méthode pour créer un objet Virement à partir d'un JSON
  factory Virement.fromJson(Map<String, dynamic> json) {
    return Virement(
      virementId: json['virement_id'],
      nomComplet: json['nom_complet'],
      banque: json['banque'],
      iban: json['iban'],
      bicSwift: json['bic_swift'],
      rib: json['rib'],
      pays: json['pays'],
    );
  }
}
