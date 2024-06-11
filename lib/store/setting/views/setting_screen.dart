import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/setting/cubit/user_cubit.dart';
import 'package:anwer_shop/store/setting/cubit/user_state.dart';
import 'package:anwer_shop/store/store_items/cubit/user_info_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/custom_container.dart';
import 'widgets/user_data_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDataCubit()..fetchUserData(),
      child: Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(EvaIcons.editOutline, color: Colors.white),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    surfaceTintColor: ColorConstant.bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: ColorConstant.primaryColor,
                    content: const UserDataPage(),
                    actions: const [],
                  );
                },
              );
            },
          ),
          backgroundColor: ColorConstant.bgColor,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'تفاصيل المستخدم',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        body: BlocBuilder<UserDataCubit, UserDataState>(
          builder: (context, state) {
            if (state is UserDataLoading) {
              return Center(child: loadingIndicator(color: Colors.white));
            } else if (state is UserDataLoaded) {
              final userData = state.userData;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<UserInfoCubit, UserInfoState>(
                      builder: (context, userInfoState) {
                        return Container(
                          width: 128.0,
                          height: 100.0,
                          margin: const EdgeInsets.only(
                            top: 30.0,
                            bottom: 30.0,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: userInfoState is ImageLoading
                              ? loadingIndicator()
                              : userInfoState is ImageLoaded
                                  ? StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text('Error: ');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return loadingIndicator(
                                            color: Colors.white,
                                          );
                                        }
                                        final userData = snapshot.data!.data()
                                            as Map<String, dynamic>;
                                        return Image.network(
                                            userData['profilePicture']);
                                      })
                                  : Image.asset('assets/user.png'),
                        );
                      },
                    ),
                    CustomContainerUser(
                      text1: ':  الاسم',
                      text2: userData['name'] ?? 'غير متوفر',
                    ),
                    CustomContainerUser(
                      text1: ':  البريد الإلكتروني',
                      text2: userData['email'] ?? 'غير متوفر',
                    ),
                    CustomContainerUser(
                      text1: ' :   رقم الهاتف',
                      text2: userData['PhoneNumber'] ?? 'غير متوفر',
                    ),
                  ],
                ),
              );
            } else if (state is UserDataError) {
              return const Center(
                  child: Text('حدث خطأ أثناء جلب بيانات المستخدم',
                      style: TextStyle(color: Colors.white)));
            } else {
              return const Center(
                  child: Text('حدث خطأ غير متوقع',
                      style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ),
    );
  }
}

class UserDataPage extends StatelessWidget {
  const UserDataPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDataCubit()..fetchUserData(),
      child: const UserDataForm(),
    );
  }
}
