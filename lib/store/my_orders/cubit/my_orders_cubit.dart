import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/orders_model.dart';

part 'my_orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState([]));

  fetchUserOrders() async{
    emit(const OrdersLoading([]));
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("Orders")
          .where("User",isEqualTo: user.uid)
          .orderBy('orderDate', descending: true)
          // .snapshots()
          .get().then((event) {
        final orders = event.docs
            .map((doc) {
          final data = doc.data();
          return OrderModel(
            userId: data['User'] ?? "",
            documentId: doc.id,
            totalPrice: double.tryParse(data['totalPrice'].toString()) ?? 0.0, // Parse totalPrice as a double
            contactNumber: data['contactNumber'] ?? "",
            address: data['location'] ?? "",
            status: data['status'] ?? "",
            products: data['products'] ?? [],
            orderDate:_formatDate( data['orderDate']),
            isAccepted: data['isAccepted'] ?? false,
            isDelivered: data['isDelivered'] ?? false,
            isCanceled: data['isCanceled'] ?? false,
          );
        }).toList();

        emit(OrdersLoaded(orders));
      }, onError: (error) {
        emit(OrdersError("Error fetching orders: $error"));
      });
    } else {
      emit(OrdersError("User not logged in"));
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return "";
    try {
      final parsedDate = DateTime.parse(date.toString());
      final formattedDate = "${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.year}";
      final formattedTime = "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";
      return "$formattedDate $formattedTime";
    } catch (e) {
      // Handle any parsing errors
      return "";
    }
  }

}
