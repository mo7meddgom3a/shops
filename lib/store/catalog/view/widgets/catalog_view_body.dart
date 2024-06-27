
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/store_items/cubit/store_items_cubit.dart';
import 'package:anwer_shop/store/store_items/views/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../store_items/cubit/categories_cubit.dart';

class CatalogViewBody extends StatelessWidget {
  const CatalogViewBody({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreItemsCubit, StoreItemsState>(
      builder: (context, state) {
        if (state.status == StoreItemsStatus.loaded) {
          final categoryProducts = state.products
              ?.where((element) => element.category == category.name)
              .toList();
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .65 , crossAxisSpacing: 10),
            itemCount: categoryProducts?.length,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ProductCard(
                    product: categoryProducts![index],
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

    // ProductCard(
    // product: ProductModel.products[0],);
  }
}
