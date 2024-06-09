import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../user_repo.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final UserRepo userRepo;
  late StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({required this.userRepo}) : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepo.user.listen((user) {
      add(AuthenticationUserChanged(user: user));
    });
    on<AuthenticationUserChanged>((event, emit) {
      if (event.user != null){
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}