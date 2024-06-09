import 'package:anwer_shop/auth/models/user_model.dart';
import 'package:anwer_shop/auth/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseUserRepo implements UserRepo {
  final FirebaseAuth _firebaseAuth;

  final userCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserModel> signUp(
      {required UserModel myUser, required String password}) async {
    try {
      // Create the user with email and password
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(myUser.name);

      await userCredential.user!.reload();
      final User updatedUser = _firebaseAuth.currentUser!;

      myUser = myUser.copyWith(userId: updatedUser.uid);

      return myUser;
    } catch (e) {
      throw Exception(e);
    }
  }


  @override
  Future<void> setUserData(UserModel user) async {
    try {
      await userCollection.doc(user.userId).set(user.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> logOut() {
    try {
      return _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }
}
