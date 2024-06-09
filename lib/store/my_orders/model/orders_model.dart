import 'dart:convert';

import 'package:equatable/equatable.dart';

final class OrderModel extends Equatable {
  final String documentId; // Updated
  final double totalPrice;
  final String contactNumber;
  final String address;
  final String status;
  final List products;
  final String orderDate;
  final bool isAccepted;
  final bool isDelivered;
  final bool isCanceled;

  final String userId;

  const OrderModel({
    required this.userId,
    required this.isCanceled,
    required this.isAccepted,
    required this.isDelivered,
    required this.totalPrice,
    required this.contactNumber,
    required this.address,
    required this.status,
    required this.products,
    required this.orderDate,
    required this.documentId, // Updated
  });


  // OrderModel copyWith({
  //   String? documentId,
  //   double? totalPrice,
  //   String? contactNumber,
  //   String? address,
  //   String? status,
  //   List? products,
  //   String? orderDate,
  //   bool? isAccepted,
  //   bool? isDelivered,
  //   bool? isCanceled,
  // }) {
  //   return OrderModel(
  //     userId: userId,
  //     isCanceled: isCanceled ?? this.isCanceled,
  //     documentId: documentId ?? this.documentId,
  //     totalPrice: totalPrice ?? this.totalPrice,
  //     contactNumber: contactNumber ?? this.contactNumber,
  //     address: address ?? this.address,
  //     status: status ?? this.status,
  //     products: products ?? this.products,
  //     orderDate: orderDate ?? this.orderDate,
  //     isAccepted: isAccepted ?? this.isAccepted,
  //     isDelivered: isDelivered ?? this.isDelivered,
  //   );
  // }

  Map<String , dynamic> toMap(){
    return {
      'documentId': documentId,
      'totalPrice': totalPrice,
      'contactNumber': contactNumber,
      'address': address,
      'status': status,
      'products': products,
      'orderDate': orderDate,
      'isAccepted': isAccepted,
      'isDelivered': isDelivered,
      'isCanceled': isCanceled,
    };
  }

  factory OrderModel.fromSnapshot(Map<String,dynamic> snapshot){
    return OrderModel(
      userId: snapshot['User'],
      isCanceled: snapshot['isCanceled'],
      documentId: snapshot['documentId'],
      totalPrice: snapshot['totalPrice'],
      contactNumber: snapshot['contactNumber'],
      address: snapshot['address'],
      status: snapshot['status'],
      products: snapshot['products'],
      orderDate: snapshot['orderDate'],
      isAccepted: snapshot['isAccepted'],
      isDelivered: snapshot['isDelivered'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;
  @override
  List<Object?> get props => [
    documentId,
    totalPrice,
    contactNumber,
    address,
    status,
    products,
    orderDate,
    isAccepted,
    isDelivered,
  ];
}
