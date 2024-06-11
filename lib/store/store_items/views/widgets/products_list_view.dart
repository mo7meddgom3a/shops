
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:anwer_shop/store/store_items/views/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.31,
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ProductCard(
              product: products[index],
            ),
          );
        },
      ),
    );
  }
}
