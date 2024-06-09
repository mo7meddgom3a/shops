import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:equatable/equatable.dart';

class WishListModel extends Equatable {
  final List<ProductModel> products;

  const WishListModel({required this.products});

  @override
  List<Object?> get props => [products];
}
