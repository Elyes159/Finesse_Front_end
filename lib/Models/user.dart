class Users{
  late final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  late final String? verifCode;

  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.verifCode,
  });

  factory Users.fromJson(Map<String,dynamic> json){
    return Users(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      verifCode: json['verfication_code'] ?? '',
    );
  }
}