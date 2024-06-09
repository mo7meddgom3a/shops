
part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryModel> items;

  CategoriesLoaded({required this.items});

}


class CategoriesError extends CategoriesState {}

//Categories Model

class CategoryModel extends Equatable {
  final String name;
  final String imageUrl;

  const CategoryModel({required this.name, required this.imageUrl});

  @override

  List<Object?> get props => [name, imageUrl];

}