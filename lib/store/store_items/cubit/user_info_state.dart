part of 'user_info_cubit.dart';

@immutable
sealed class UserInfoState {}

final class UserInfoInitial extends UserInfoState {}
class LoggedOut extends UserInfoState {}

class ImageLoaded extends UserInfoState {
  final String imageUrl;

  ImageLoaded({required this.imageUrl});
}

class ImageLoading extends UserInfoState {}

class ImageError extends UserInfoState {}