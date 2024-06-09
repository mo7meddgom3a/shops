part of 'wish_list_cubit.dart';

@immutable
sealed class WishListState extends Equatable{}

class WishListInitial extends WishListState {
  @override
  List<Object?> get props => [];
}

class WishListLoading extends WishListState {
  @override
  List<Object?> get props => [];
}

class WishListLoaded extends WishListState {
  final List<ProductModel> wishListItems;

  WishListLoaded(this.wishListItems);

  @override
  List<Object?> get props => [wishListItems];
}

class WishListError extends WishListState {
  final String message;

  WishListError(this.message);

  @override
  List<Object?> get props => [message];
}
