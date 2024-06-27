import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/setting/cubit/user_cubit.dart';
import 'package:anwer_shop/store/setting/cubit/user_state.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataForm extends StatelessWidget {
  const UserDataForm({Key? key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserDataCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'تعديل البيانات الشخصية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textDirection: TextDirection.rtl,
              ),

              TextFormField(
                keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                controller: cubit.phoneNumberController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "رقم الهاتف",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 16),
              BlocBuilder<UserDataCubit, UserDataState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: ColorConstant.primaryColor,
                        ),
                        onPressed: () {
                          cubit.insertProfilePic();
                        },
                        child: const Text(
                          "اختر صورة",
                          style: TextStyle(color: Colors.white),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      state.status == UserDataStatus.loaded
                          ? Icon(
                        EvaIcons.checkmarkCircle2,
                        color: ColorConstant.green,
                      )
                          : state.status == UserDataStatus.error
                          ? loadingIndicator()
                          : const SizedBox.shrink()
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ColorConstant.bgColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.white),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ColorConstant.primaryColor,
                    ),
                    onPressed: () async {
                      await cubit.updateUser(context);
                      // Navigator.pushReplacementNamed(context, "Settings");
                    },
                    child: const Text(
                      'تحديث',
                      style: TextStyle(color: Colors.white),
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
