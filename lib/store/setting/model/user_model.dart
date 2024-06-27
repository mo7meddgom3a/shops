
class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

}
