import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';


sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpProcess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final SignUpFailureType failureType;

  const SignUpFailure({required this.failureType});

  @override
  List<Object> get props => [failureType];
}
