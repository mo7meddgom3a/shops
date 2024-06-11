import 'package:anwer_shop/store/checkout/models/address.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../store_items/models/product_model.dart';
part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  Position? _currentPosition;
  List<ProductModel> products = [];
  PlaceOrderCubit() : super(PlaceOrderState());

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
            imageUrl: const [],
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
    emit(state.copyWith(state: PlaceOrderStatus.loading));

    if (locationController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List productsMapList = product.map((product) => product.toMap()).toList();
        double totalPrice = await totalCartPrice();
        Map<String, dynamic> orderItem = {
          "status": "pending",
          "User": user.uid,
          "location": locationController.text,
          "contactNumber": contactNumberController.text,
          "notes": notesController.text,
          "products": productsMapList,
          "orderDate": DateTime.now().toString(),
          "totalPrice": totalPrice,
          "maplocation" :state.mapLocation
        };
        wishList.add(orderItem);
      }
      emit(state.copyWith(state: PlaceOrderStatus.loaded));
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

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;

      if (_currentPosition != null) {
        emit(state.copyWith(
          currentLocation: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          locationFetched: true,
        ));
      } else {
        emit(state.copyWith(errorMessage: "Failed to fetch current location"));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> getAddressFromLatLng() async {
    emit(state.copyWith(state: PlaceOrderStatus.loading));
    if (_currentPosition == null) {
      emit(state.copyWith(errorMessage: "Current position is null"));
      return;
    }
    try {
      final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}";
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks[0];
        emit(state.copyWith(
            currentLocationName: "${place.street}-${place.administrativeArea}-${place.country} ",mapLocation: googleMapsUrl
        ));
      } else {
        emit(state.copyWith(errorMessage: ""));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    locationController.dispose();
    contactNumberController.dispose();
    notesController.dispose();
    return super.close();
  }
}
