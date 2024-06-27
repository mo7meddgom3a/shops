part of 'cart_cubit.dart';

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class CartLoading extends CartState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class CartLoaded extends CartState {
  final List<ProductModel> cartItems;

  const CartLoaded(this.cartItems);

  @override
  // TODO: implement props
  List<Object?> get props => [cartItems];
}

final class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class IsInCart extends CartState {
  final bool isCart;

  const IsInCart(this.isCart);

  @override
  List<Object?> get props => [isCart];


}