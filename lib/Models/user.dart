class Users {
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String? avatar;
  final String fullName;
  final String address;
  final bool isEmailVerified;
  final String verificationCode;
  final String description;

  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.avatar,
    required this.fullName,
    required this.address,
    required this.isEmailVerified,
    required this.verificationCode,
    required this.description,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['user_id'],
      username: json['user_profile']['username'],
      email: json['user_profile']['email'],
      phoneNumber: json['user_profile']['phone_number'],
      firstName: json['user_profile']['first_name'],
      lastName: json['user_profile']['last_name'],
      avatar: json['user_profile']['avatar'],
      fullName: json['user_profile']['full_name'],
      address: json['user_profile']['address'],
      isEmailVerified: json['user_profile']['is_email_verified'],
      verificationCode: json['user_profile']['verification_code'],
      description: json['user_profile']['description'],
    );
  }
}

class UsersGoogle {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String avatar;

  UsersGoogle({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.avatar,
  });

  factory UsersGoogle.fromJson(Map<String, dynamic> json) {
    return UsersGoogle(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      avatar: json['avatar'],
    );
  }
}
