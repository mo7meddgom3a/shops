import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../store_items/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  CollectionReference wishList = FirebaseFirestore.instance.collection('cart');

   addToFireStoreCart({required ProductModel product}) async {
    try {
      // Create a list to hold the maps

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Create a map for the wishlist item
        Map<String, dynamic> wishlistItem = {
          "User": user.uid,
          "name": product.name,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "category": product.category,
          "description": product.description,
          "elementID": product.productID,
          "productCount": 1,
        };
        wishList.doc(user.uid).collection("items").doc(product.productID).set(
              wishlistItem,
            );
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Stream fetchCartItems() {
    emit(CartLoading());
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        FirebaseFirestore.instance
            .collection("cart")
            .doc(user.uid)
            .collection("items")
            .snapshots()
            .listen((snapshot) {
          List<ProductModel> products = snapshot.docs.map((doc) {
            return ProductModel(
              productID: doc.id,
              name: doc["name"],
              imageUrl: List<String>.from(doc['imageUrl']?? []),
              price: doc["price"],
              category: doc["category"],
              description: doc["description"],
              isRecommended: false,
              isPopular: false,
              productCount: doc["productCount"],
            );
          }).toList();
          emit(CartLoaded(products));
        });
      } catch (e) {
        emit(CartError(e.toString()));
      }
    } else {
      emit(const CartError("User not logged in" ,));
    }
    return const Stream.empty();

  }

  void removeFromCart({required ProductModel product}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .doc(product.productID)
          .delete();
    }
  }

  void incrementProductCount({required ProductModel product}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .doc(product.productID)
          .update({"productCount": FieldValue.increment(1)});
    }
  }

  void decrementProductCount({required ProductModel product}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .doc(product.productID)
          .update({"productCount": FieldValue.increment(-1)});

    }
  }

  void clearCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    }
  }

  // git the actual product count of the type int from the firestore
Stream <int> productCount ({required ProductModel product}) async* {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .snapshots();
      await for (QuerySnapshot snapshot in usersStream) {
        for (QueryDocumentSnapshot element in snapshot.docs) {
          if (element.id == product.productID) {
            yield element.get("productCount");
          }
        }
      }
      }
    yield 0;
  }

  // get the total price of the cart items
  Stream<double> totalPrice() {
    StreamController<double> controller = StreamController<double>();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        double totalPrice = 0;
        for (var element in snapshot.docs) {
          totalPrice += element.get("price") * element.get("productCount");
        }
        controller.add(totalPrice); // Emit the total price
      });
    } else {
      // If user is null, emit 0 as the total price
      controller.add(0);
    }

    return controller.stream;
  }
  isProductInCart({required ProductModel product}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .get()
          .then((value) {
        for (var element in value.docs) {
          if (element.id == product.productID) {
            return true;
          }
        }
      });
    }
    return false;
  }

  Stream numberOfOrdersInCart(){
    StreamController<int> controller = StreamController<int>();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        controller.add(snapshot.docs.length);
      });
    } else {
      controller.add(0);
    }
    return controller.stream;
  }
}
