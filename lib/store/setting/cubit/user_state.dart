// Define your states
abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final Map<String, dynamic> userData;

  UserDataLoaded(this.userData);
}

class UserDataError extends UserDataState {}

class UserImageLoaded extends UserDataState {}

class UserImageLoading extends UserDataState {}

class UserImageAdded extends UserDataState {}
