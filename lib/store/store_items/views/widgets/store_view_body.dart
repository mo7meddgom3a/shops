import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/store_items/cubit/store_items_cubit.dart';
import 'package:anwer_shop/store/store_items/views/widgets/scroller_card_categories.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categories_cubit.dart';
import 'product_card.dart';
import 'products_list_view.dart';
import 'section_title.dart';

class StoreViewBody extends StatelessWidget {
  const StoreViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<StoreItemsCubit>().fetchStoreItems();
    context.read<StoreCategoriesCubit>().loadCategoriesItems();
    context.read<WishListCubit>().fetchWishListItems();
    context.read<CartCubit>().fetchCartItems();
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StoreItemsCubit>().fetchStoreItems();
        context.read<StoreCategoriesCubit>().loadCategoriesItems();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SectionTitle(title: "Categories"),

                  BlocBuilder<StoreCategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoaded) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            autoPlay: true,
                          ),
                          items: state.items.map((name) {
                            return ScrollerCardCategorise(category: name);
                          }).toList(),
                        );
                      } else {
                        return Center(
                            child: loadingIndicator(
                          color: Colors.white,
                        ));
                      }
                    },
                  ),
                  const SectionTitle(title: "RECOMMENDED"),
                  BlocBuilder<StoreItemsCubit, StoreItemsState>(
                    builder: (context, state) {
                      if (state is StoreItemsLoaded) {
                        final recommendedProducts =
                            state.recommendedProducts.toSet().toList();
                        return recommendedProducts.isNotEmpty
                            ? ProductsListView(products: recommendedProducts)
                            : const Text(
                                "No items in RECOMMENDED",
                                style: TextStyle(color: Colors.white),
                              );
                      } else {
                        return Center(
                          child: loadingIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                  const SectionTitle(title: "MOST POPULAR"),
                  BlocBuilder<StoreItemsCubit, StoreItemsState>(
                    builder: (context, state) {
                      if (state is StoreItemsLoaded) {
                        final popularProducts =
                            state.popularProducts.toSet().toList();
                        return popularProducts.isNotEmpty
                            ? ProductsListView(products: popularProducts)
                            : const Text("No items in POPULAR",
                                style: TextStyle(color: Colors.white));
                      } else {
                        return Center(
                          child: loadingIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                  const SectionTitle(title: "All Items"),
                ],
              ),
            ),
          ),
          BlocBuilder<StoreItemsCubit, StoreItemsState>(
            builder: (context, state) {
              if (state is StoreItemsLoaded) {
                final allProducts = state.products.toSet().toList();
                return allProducts.isNotEmpty
                    ? SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16,),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 0.5,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ProductCard(product: allProducts[index]);
                            },
                            childCount: allProducts.length,
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter(
                        child: Text(
                          "No items in All Items",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
              } else {
                return SliverToBoxAdapter(
                  child: Center(
                    child: loadingIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
