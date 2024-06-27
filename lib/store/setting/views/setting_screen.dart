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
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDataCubit()..fetchUserData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            icon: const Icon(EvaIcons.editOutline, color: Colors.white),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    surfaceTintColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.blueGrey,
                    content: const UserDataPage(),
                    actions: const [],
                  );
                },
              );
            },
          ),
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
            if (state.status == UserDataStatus.loading) {
              return Center(child: loadingIndicator(color: Colors.white));
            } else if (state.status == UserDataStatus.loaded) {
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
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
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
                                return Image.network(userData['profilePicture']);
                              })
                              : Image.asset('assets/user.png'),
                        );
                      },
                    ),
                    CustomContainerUser(
                      text1: ':  الاسم',
                      text2: userData?.name ?? 'غير متوفر',
                    ),
                    CustomContainerUser(
                      text1: ':  البريد الإلكتروني',
                      text2: userData?.email ?? 'غير متوفر',
                    ),
                    CustomContainerUser(
                      text1: ' :   رقم الهاتف',
                      text2: userData?.phoneNumber ?? 'غير متوفر',
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'حدث خطأ غير متوقع',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class UserDataPage extends StatelessWidget {
  const UserDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDataCubit()..fetchUserData(),
      child: const UserDataForm(),
    );
  }
}
