import 'package:flutter/material.dart';

import '../cubit/my_orders_cubit.dart';

class CustomOrdersView extends StatelessWidget {
  const CustomOrdersView({
    super.key, required this.state, required this.index,
  });
  final OrdersState state;
  final int index;

  @override
  Widget build(BuildContext context) {
    var order = state.orders[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[300],
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order ID: ${order.documentId}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Order Date: ${order.orderDate}"),
              const SizedBox(height: 8),
              const Divider(),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: order.products.length,
                itemBuilder: (context, productIndex) {
                  var product = order.products[productIndex];
                  return ListTile(
                    title: Text("${product['name']}"),
                    subtitle: Text(
                      "Price: \$${product['price']} | Quantity: ${product['productCount']}",
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(
                  "Phone Number",
                  style: TextStyle(fontSize: 14,),
                ),
                 subtitle:  Text(
                   order.contactNumber,
                   style: const TextStyle(fontSize: 14,),
                 ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Shipping Address"),
                subtitle: Text(order.address),

              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Status:',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                      const SizedBox(width: 5,),
                      Text(
                        order.status,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: order.status == "Delivered"
                                ? Colors.green
                                : order.status == "Canceled"
                                ? Colors.red
                                : Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Total: ${order.totalPrice}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
