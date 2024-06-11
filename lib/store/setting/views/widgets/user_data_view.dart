import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/setting/cubit/user_cubit.dart';
import 'package:anwer_shop/store/setting/cubit/user_state.dart';
import 'package:anwer_shop/store/setting/views/widgets/user_data_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserDataView extends StatelessWidget {
  const UserDataView({super.key,  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return Center(
              child: loadingIndicator(
            color: Colors.white,
          ));
        }
        return const UserDataForm();
      },
    );
  }
}
