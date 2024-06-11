import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> getUserImage() async {
    emit(ImageLoading());
    debugPrint("image loading");
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (documentSnapshot.exists) {
        final String url = documentSnapshot.get("profilePicture") as String;
        emit(ImageLoaded(imageUrl: url));
      } else {
        emit(ImageLoaded(
            imageUrl:
            "https://avatars.githubusercontent.com/u/71256?s=200&v=4"));
      }
    } catch (err) {
      debugPrint("error loading image $err");
      emit(ImageError());
    }
  }

  void logout() async {
    try {
      await _auth.signOut(); // Sign out the user
      emit(LoggedOut());
    } catch (e) {
      debugPrint('Error logging out: $e');
      // Handle logout error if any
    }
  }


}
