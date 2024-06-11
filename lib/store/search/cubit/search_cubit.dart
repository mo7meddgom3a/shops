import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      // Replace with actual search logic to fetch products based on the query
      final List<ProductModel> searchResults = await _fetchProducts(query);
      emit(SearchLoaded(items: searchResults));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  Future<List<ProductModel>> _fetchProducts(String query) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return querySnapshot.docs.map((doc) {
        return ProductModel(
          productID: doc.id,
          name: doc['name'] ?? '',
          imageUrl: List<String>.from(doc['imageUrls'] ?? []),
          price: doc['price'] ?? 0.0,
          category: doc['category'] ?? '',
          description: doc['description'] ?? '',
          isRecommended: doc['isRecommended'] ?? false,
          isPopular: doc['isPopular'] ?? false,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }}
