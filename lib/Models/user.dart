class Artist {
  final int id;
  final String fullName;
  final String avatar;

  Artist({
    required this.id,
    required this.fullName,
    required this.avatar,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      fullName: json['full_name'] ??"inconnu",
      avatar: json['avatar']?? "image",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar': avatar,
    };
  }
}


class Users {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String? avatar;
  final String fullName;
  final String address;
  final bool? isEmailVerified;
  final String? verificationCode;
  final bool hasStory;
  final String description;
  final String activite; // Liste des artistes associés

  Users( {
    required this.description,
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.avatar,
    required this.fullName,
    required this.address,
    this.isEmailVerified,
    this.verificationCode,
    required this.hasStory,
    required this.activite, // Ajout du paramètre artists dans le constructeur
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    var artistList = json['user_profile']['artists'] as List?;
    List<Artist> artists = artistList != null
        ? artistList.map((artistJson) => Artist.fromJson(artistJson)).toList()
        : [];

    return Users(
      id: json['user_id'],
      username: json['user_profile']['username'],
      email: json['user_profile']['email'],
      phoneNumber: json['user_profile']['phone_number'],
      avatar: json['user_profile']['avatar'],
      fullName: json['user_profile']['full_name'],
      address: json['user_profile']['address'],
      isEmailVerified: json['user_profile']['is_email_verified'] ?? true,
      verificationCode: json['user_profile']['verification_code'],
      hasStory: json['user_profile']['hasStory'],
      activite: json['user_profile']['activite'] ?? "Autres",
      description: json["user_profile"]["description"] ?? "" // Remplir la liste des artistes
    );
  }

  Users copyWith({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? avatar,
    String? username,
    String? description,
    String? activite, // Ajouter artists dans copyWith
  }) {
    return Users(
      id: id,
      description: description ?? this.description ,
      username: this.username,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      isEmailVerified: isEmailVerified,
      verificationCode: verificationCode,
      hasStory: hasStory,
      activite: activite ?? this.activite, // Prendre la liste des artistes mise à jour ou l'ancienne
    );
  }
}
