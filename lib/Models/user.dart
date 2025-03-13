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

  Users({
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
  });

  factory Users.fromJson(Map<String, dynamic> json) {
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
    );
  }

  Users copyWith({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? avatar,
    String? username
  }) {
    return Users(
      id: id,
      username: this.username,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      isEmailVerified: isEmailVerified,
      verificationCode: verificationCode,
      hasStory: hasStory,
    );
  }
}
