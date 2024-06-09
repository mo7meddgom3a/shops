import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductModel extends Equatable {
  final String name, description;
  final List <String> imageUrl;
  final num price;
  final String category;

  final String productID;
  final bool isRecommended;
  final bool isPopular;

  int productCount;

   ProductModel( {
    this.productCount = 1 ,
    required this.productID,
    required this.name,
    required this.imageUrl,
     this.price = 0,
     this.category = "",
    required this.isRecommended,
    required this.isPopular,
    required this.description,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        name,
        imageUrl,
        price,
        category,
        isRecommended,
        isPopular,
      ];


  toMap() {
    return {
      "productID": productID,
      "name": name,
      "imageUrl": imageUrl,
      "price": price,
      "category": category,
      "isRecommended": isRecommended,
      "isPopular": isPopular,
      "description": description,
      "productCount": productCount,
    };
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ProductModel(
      productID: snapshot['productID'],
      name: snapshot['name'],
      imageUrl: snapshot['imageUrl'],
      price: snapshot['price'],
      category: snapshot['category'],
      isRecommended: snapshot['isRecommended'],
      isPopular: snapshot['isPopular'],
      description: snapshot['description'],
    );
  }
}
