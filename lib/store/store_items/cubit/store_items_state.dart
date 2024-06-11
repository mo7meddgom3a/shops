part of 'store_items_cubit.dart';
enum StoreItemsStatus { initial, loading, loaded, error }

class StoreItemsState extends Equatable {
  final StoreItemsStatus status;
  final List<ProductModel>? products;
  final List<ProductModel>? recommendedProducts;
  final List<ProductModel>? popularProducts;
  final String? errorMessage;
  final int? currentIndex;

  const StoreItemsState({
    required this.status,
    this.products,
    this.recommendedProducts,
    this.popularProducts,
    this.errorMessage,
    this.currentIndex,
  });

  @override
  List<Object?> get props => [
    status,
    products,
    recommendedProducts,
    popularProducts,
    errorMessage,
    currentIndex,
  ];

  StoreItemsState copyWith({
    StoreItemsStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? recommendedProducts,
    List<ProductModel>? popularProducts,
    String? errorMessage,
    int? currentIndex,
  }) {
    return StoreItemsState(
      status: status ?? this.status,
      products: products ?? this.products,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      popularProducts: popularProducts ?? this.popularProducts,
      errorMessage: errorMessage ?? this.errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}