import 'dart:async';
import 'dart:io';

import 'package:anwer_shop/store/setting/cubit/user_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motion_toast/motion_toast.dart';


class UserDataCubit extends Cubit<UserDataState> {
  final TextEditingController phoneNumberController = TextEditingController();
  late XFile selectedImage;

  UserDataCubit() : super(UserDataInitial());

  void fetchUserData() async {
    try {
      emit(UserDataLoading());
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final userData = userDataSnapshot.data() as Map<String, dynamic>;
      phoneNumberController.text = userData['PhoneNumber'] ?? '';
      emit(UserDataLoaded(userData));
    } catch (e) {
      emit(UserDataError());
    }
  }

  Future<void> insertProfilPic() async {
    emit(UserImageLoading());
    try {
      final picker = ImagePicker();
      final selectedFile = await picker.pickImage(source: ImageSource.gallery);

      if (selectedFile != null) {
        selectedImage = selectedFile;
        emit(UserImageAdded());
        return;
      }
    } catch (e) {
      emit(UserDataError());
    }
  }

  Future<void> saveImage() async {
    try {
      if (selectedImage.path.isNotEmpty) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}');
        UploadTask uploadTask =
        storageReference.putFile(File(selectedImage.path));
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();

        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        await userDocRef.set({'profilePicture': url}, SetOptions(merge: true));
      }
    } catch (e) {
      emit(UserDataError());
    }
  }

  Future<void> updateUser(BuildContext context) async {
    emit(UserDataLoading());
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      await userDocRef.update({
        'PhoneNumber': phoneNumberController.text,
      });
      await saveImage();

      MotionToast.success(
        title: const Text("Success 🎉"),
        description: const Text("User data updated successfully"),
      ).show(context);
      // Emit a new state with the updated user data
      final updatedUserData = {
        'PhoneNumber': phoneNumberController.text,
      };
      emit(UserDataLoaded(updatedUserData));

      // Optional: Pop the page if it's still mounted
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      emit(UserDataError());
    }
  }

  @override
  Future<void> close() {
    phoneNumberController.dispose();
    return super.close();
  }
}
