import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());
}
