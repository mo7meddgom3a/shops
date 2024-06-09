part of 'place_order_cubit.dart';

@immutable
sealed class PlaceOrderState {}


final List<ProductModel> products = [];

final class PlaceOrderInitial extends PlaceOrderState {}

final class PlaceOrderLoading extends PlaceOrderState {}

final class PlaceOrderSuccess extends PlaceOrderState {
final List<ProductModel> product;


  PlaceOrderSuccess(this.product);
}

final class PlaceOrderFailed extends PlaceOrderState {
  final String error;

  PlaceOrderFailed(this.error);
}
