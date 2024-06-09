import 'package:equatable/equatable.dart';

class UserModel extends Equatable {

  final String email;
  final String name;
  final String userId;
  const UserModel({
    required this.name,
    required this.userId,
    required this.email,
  });

  static const empty = UserModel(email: '', name: '', userId: '');

  UserModel copyWith({
    String? email,
    String? name,
    String? userId,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'userId': userId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ,
      name: map['name'] ,
      userId: map['userId'] ,
    );
  }

  @override
  List<Object> get props => [email, name, userId];
}
