import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'store_items_state.dart';


class StoreItemsCubit extends Cubit<StoreItemsState> {
  StoreItemsCubit() : super(const StoreItemsState(status: StoreItemsStatus.initial));

  CollectionReference wishList = FirebaseFirestore.instance.collection('items');

  void fetchStoreItems() {
    emit(state.copyWith(status: StoreItemsStatus.loading));

    FirebaseFirestore.instance.collection("items").snapshots().listen(
          (querySnapshot) {
        List<ProductModel> recommendedProducts = [];
        List<ProductModel> popularProducts = [];
        List<ProductModel> products = [];
        for (var element in querySnapshot.docs) {
          final product = ProductModel(
            productID: element.id,
            name: element["name"] ?? '',
            imageUrl: List<String>.from(element['imageUrls'] ?? []),
            price: element["price"] ?? 0.0,
            category: element["category"] ?? '',
            description: element["description"] ?? '',
            isRecommended: element['isRecommended'] ?? false,
            isPopular: element['isPopular'] ?? false,
          );

          if (product.isRecommended && !recommendedProducts.contains(product)) {
            recommendedProducts.add(product);
          }

          if (product.isPopular && !popularProducts.contains(product)) {
            popularProducts.add(product);
          }

          products.add(product);
        }
        emit(state.copyWith(
          status: StoreItemsStatus.loaded,
          products: products,
          recommendedProducts: recommendedProducts,
          popularProducts: popularProducts,
        ));
      },
      onError: (e) {
        emit(state.copyWith(status: StoreItemsStatus.error, errorMessage: e.toString()));
      },
    );
  }

  void changeScreen(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}