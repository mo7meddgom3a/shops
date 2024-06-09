import 'package:anwer_shop/auth/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user_repo.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepo _userRepository;

  SignUpBloc({
    required UserRepo userRepository
  }) : _userRepository = userRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        UserModel user = await _userRepository.signUp(password: event.password, myUser: event.user);
        await _userRepository.setUserData(user);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure());
      }
    });
  }
}