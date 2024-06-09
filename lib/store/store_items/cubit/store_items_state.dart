part of 'store_items_cubit.dart';

@immutable
sealed class StoreItemsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class StoreItemsInitial extends StoreItemsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class StoreItemsLoading extends StoreItemsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class StoreItemsLoaded extends StoreItemsState {
  final List<ProductModel> products;
  final List<ProductModel> recommendedProducts;

  final List<ProductModel> popularProducts;


  StoreItemsLoaded(
      {required this.products, required this.recommendedProducts, required this.popularProducts});

  @override
  // TODO: implement props
  List<Object?> get props => [products, recommendedProducts, popularProducts];

}

final class StoreItemsError extends StoreItemsState {
  final String message;

  StoreItemsError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
