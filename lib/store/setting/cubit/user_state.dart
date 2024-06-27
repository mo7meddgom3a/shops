// Define your states
import '../model/user_model.dart';

enum UserDataStatus { initial, loading, loaded, error, imageLoading, imageAdded }

class UserDataState {
  final UserDataStatus status;
  final UserModel? userData;
  final String? errorMessage;

  const UserDataState({
    this.status = UserDataStatus.initial,
    this.userData,
    this.errorMessage,
  });

  UserDataState copyWith({
    UserDataStatus? status,
    UserModel? userData,
    String? errorMessage,
  }) {
    return UserDataState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
