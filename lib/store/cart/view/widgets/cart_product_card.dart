
import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/store_items/cubit/store_items_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../store_items/models/product_model.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "${product.price}\$",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              BlocBuilder<StoreItemsCubit, StoreItemsState>(
                builder: (context, state) {
                  final isProductAvailable = state is StoreItemsLoaded &&
                      state.products.any((element) =>
                      element.productID == product.productID);
                  if (!isProductAvailable) {
                    context.read<CartCubit>().removeFromCart(product: product);
                  }else {
                    return StreamBuilder<int>(
                      stream:
                      context.read<CartCubit>().productCount(product: product),
                      builder: (context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (snapshot.data == 1) {
                                    await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),

                                          backgroundColor: ColorConstant.bgColor,
                                          title: const Text(
                                            'Remove from cart?' , style: TextStyle(color: Colors.white),),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: ColorConstant.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<CartCubit>()
                                                    .removeFromCart(
                                                    product: product);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Remove',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    context
                                        .read<CartCubit>()
                                        .decrementProductCount(
                                        product: product);
                                  }
                                },
                                icon: const Icon(EvaIcons.minusCircleOutline,
                                    color: Colors.red),
                              ),
                              Text(
                                snapshot.data.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<CartCubit>()
                                      .incrementProductCount(product: product);
                                },
                                icon: const Icon(EvaIcons.plusCircleOutline,
                                    color: Colors.green),
                              ),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                              },
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                            ),
                            const Text("1" , style: TextStyle(color: Colors.white, fontSize: 16),),
                            IconButton(
                              onPressed: () {
                              },
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}