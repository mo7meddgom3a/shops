
import 'package:anwer_shop/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepo {
  Stream<User?> get user;
  Future<UserModel> signUp({required  UserModel myUser, required String password});

  Future<void> setUserData(UserModel user);
  Future<void> logIn({required String email, required String password});

  Future<void> logOut();
}