import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/store_items_cubit.dart';
import 'product_card.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreItemsCubit, StoreItemsState>(
      builder: (context, state) {
        if (state is StoreItemsLoaded) {
          final products = state.products;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .8 , crossAxisSpacing: 10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ProductCard(
                    product: products[index],
                    widthFactor: 2.2,
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: loadingIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
