import 'package:anwer_shop/blocs/sign_up_bloc/sign_up_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
	final UserRepository _userRepository;

	SignUpBloc({
		required UserRepository userRepository,
	})   : _userRepository = userRepository,
				super(SignUpInitial()) {
		on<SignUpRequired>((event, emit) async {
			emit(SignUpProcess());
			try {
				MyUser user = await _userRepository.signUp(event.user, event.password);
				await _userRepository.setUserData(user);
				emit(SignUpSuccess());
			} catch (e) {
				emit(const SignUpFailure(failureType: SignUpFailureType.accountAlreadyExists));
			}
		});
	}
}
