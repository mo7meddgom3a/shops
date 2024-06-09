import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'categories_state.dart';

class StoreCategoriesCubit extends Cubit<CategoriesState> {
  StoreCategoriesCubit() : super(CategoriesInitial());

  loadCategoriesItems() async {
    emit(CategoriesLoading());
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('storeCategories').get();
      final storeItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel(
          imageUrl: data['imageUrl'] ?? "",
          name: data['name'] ?? "",
        );
      }).toList();
      emit(CategoriesLoaded(items: storeItems));
    } catch (e) {
      emit(CategoriesError());
    }
  }
}
