
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/cart/view/widgets/cart_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..fetchCartItems(),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(
                child: loadingIndicator(
                  color: Colors.white,
                ));
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return  Center(
                child:SvgPicture.asset(
                  'assets/empty.svg',
                  height: 200,
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartProductCard(
                        product: state.cartItems[index],
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                          StreamBuilder<double>(
                            stream: context.read<CartCubit>().totalPrice(),
                            builder: (context, snapshot) {
                              final subtotal = snapshot.data ?? 0;
                              return Text("\$$subtotal",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // const Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Delivery Fee",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16,
                      //         )),
                      //     Text("\$10",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16,
                      //         )),
                      //   ],
                      // ),
                      const SizedBox(height: 16),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text("Total",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16,
                      //         )),
                      //     StreamBuilder<double>(
                      //       stream: context.read<CartCubit>().totalPrice(),
                      //       builder: (context, snapshot) {
                      //         final total = (snapshot.data ?? 0) + 10;
                      //         return Text("\$$total",
                      //             style: const TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 16,
                      //             ));
                      //       },
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'Checkout',
                                arguments: state.cartItems);
                          },
                          child: const Text("Checkout"),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return  Center(
              child: Text("Error loading cart items" , style: TextStyle(color: Colors.white),),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
