import 'dart:async';

import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'wish_list_state.dart';

class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());
  List<ProductModel> wishProducts = [];

  CollectionReference wishList =
      FirebaseFirestore.instance.collection('wishList');

  addToFireStoreWishList({required ProductModel product}) async {
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
        };
        wishList.doc(user.uid).collection("items").doc(product.productID).set(
              wishlistItem,
            );
      }

    } catch (e) {
      emit(WishListError(e.toString()));
    }
  }

  Stream fetchWishListItems()  {
    emit(WishListLoading());
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        FirebaseFirestore.instance
            .collection("wishList")
            .doc(user.uid)
            .collection("items")
            .snapshots()
            .listen((snapshot) {
          List<ProductModel> products = snapshot.docs.map((element) {
            return ProductModel(
              productID: element.id,
              name: element["name"],
              imageUrl: List<String>.from(element['imageUrl'] ?? []),
              price: element["price"],
              category: element["category"],
              description: element["description"],
              isRecommended: false,
              isPopular: false,
            );
          }).toList();
          emit(WishListLoaded(products));
        });
      } catch (e) {
        emit(WishListError(e.toString()));
      }
    } else {
      emit( WishListError("User not logged in"));
    }
    return const Stream.empty();

  }

  void removeFromWishList({required ProductModel product}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("wishList")
          .doc(user.uid)
          .collection("items")
          .doc(product.productID)
          .delete();
      // products.remove(product);
      // emit(WishListLoaded(products));
    }
  }

  Stream numberOfOrdersInCart() {
    StreamController<int> controller = StreamController<int>();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("wishList")
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

  Stream isItemInWishList({required ProductModel product}) {
    StreamController<bool> controller = StreamController<bool>();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("wishList")
          .doc(user.uid)
          .collection("items")
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        for (var element in snapshot.docs) {
          if (element.id == product.productID) {
            controller.add(true);
          }
        }
      });
    } else {
      controller.add(false);
    }
    return controller.stream;
  }
}
