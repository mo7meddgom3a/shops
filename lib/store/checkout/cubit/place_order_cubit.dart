import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../store_items/models/product_model.dart';
part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {

  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<ProductModel> products = [];
  PlaceOrderCubit() : super(PlaceOrderInitial());


  CollectionReference wishList = FirebaseFirestore.instance.collection('Orders');

    Future<List<ProductModel>> fetchCartItems() async {
      // emit(WishListLoading());
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("cart")
            .doc(user.uid)
            .collection("items")
            .get()
            .then((value) {
          for (var element in value.docs) {
            products.add(ProductModel(
              productID: element.id,
              name: element["name"],
              imageUrl:const [],
              price: element["price"],
              category: element["category"],
              description: element["description"],
              isRecommended: false,
              isPopular: false,

              productCount: element["productCount"],
            ));
          }
        });
        return products;
      }
      return [];
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
  Future<void> placeOrder({required List<ProductModel> product}) async {
    emit(PlaceOrderLoading());

    if (locationController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List productsMapList = product.map((product) => product.toMap()).toList();

        double totalPrice = await totalCartPrice(); // Await the total price calculation

        Map<String, dynamic> orderItem = {
          "status": "pending",
          "User": user.uid,
          "location": locationController.text,
          "contactNumber": contactNumberController.text,
          "notes": notesController.text,
          "products": productsMapList,
          "orderDate": DateTime.now().toString(),
          "totalPrice": totalPrice, // Use the awaited total price here
        };
        wishList.add(orderItem);
      }
      emit(PlaceOrderSuccess(products));
    }
  }

  Future<double> totalCartPrice() async {
    User? user = FirebaseAuth.instance.currentUser;
    double totalPrice = 0;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("items")
          .get();

      for (var element in querySnapshot.docs) {
        totalPrice += (element.get("price") * element.get("productCount"));
      }
    }
    return totalPrice;
  }


  @override
    Future<void> close() {
      locationController.dispose();
      contactNumberController.dispose();
      notesController.dispose();
      return super.close();
    }
  }
