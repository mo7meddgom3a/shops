import 'dart:async';
import 'dart:io';

import 'package:anwer_shop/store/setting/cubit/user_state.dart';
import 'package:anwer_shop/store/setting/model/user_model.dart';
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

  UserDataCubit() : super(const UserDataState());

  void fetchUserData() async {
    try {
      emit(state.copyWith(status: UserDataStatus.loading));
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final userData = UserModel.fromMap(userDataSnapshot.data()!);
      emit(state.copyWith(status: UserDataStatus.loaded, userData: userData));
    } catch (e) {
      emit(state.copyWith(status: UserDataStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> insertProfilePic() async {
    emit(state.copyWith(status: UserDataStatus.imageLoading));
    try {
      final picker = ImagePicker();
      final selectedFile = await picker.pickImage(source: ImageSource.gallery);

      if (selectedFile != null) {
        selectedImage = selectedFile;
        emit(state.copyWith(status: UserDataStatus.imageAdded));
        return;
      }
    } catch (e) {
      emit(state.copyWith(status: UserDataStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> saveImage() async {
    try {
      if (selectedImage.path.isNotEmpty) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}');
        UploadTask uploadTask = storageReference.putFile(File(selectedImage.path));
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();

        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        await userDocRef.set({'profilePicture': url}, SetOptions(merge: true));
      }
    } catch (e) {
      emit(state.copyWith(status: UserDataStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateUser(BuildContext context) async {
    emit(state.copyWith(status: UserDataStatus.loading));

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
      emit(state.copyWith(
        status: UserDataStatus.loaded,
        userData: state.userData!,
      ));

      // Optional: Pop the page if it's still mounted
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      emit(state.copyWith(status: UserDataStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    phoneNumberController.dispose();
    return super.close();
  }
}
