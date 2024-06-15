import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/cart/view/widgets/cart_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..fetchCartItems(),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(
              child: loadingIndicator(color: Colors.white),
            );
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Center(
                child: SvgPicture.asset(
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

                          StreamBuilder<double>(
                            stream: context.read<CartCubit>().totalPrice(),
                            builder: (context, snapshot) {
                              final subtotal = snapshot.data ?? 0;
                              return Text(
                                "$subtotal SAR",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                          Text(
                            "الاجمالي ",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,

                              borderRadius: BorderRadius.circular(13)
                          ),

                          child: InkWell(
                              borderRadius: BorderRadius.circular(13),
                            onTap: () {
                              Navigator.pushNamed(context, 'Checkout',
                                  arguments: state.cartItems);
                            },
                            child: Center(
                              child: const Text("طلب الان",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return const Center(
              child: Text(
                "حدث خطأ ما يرجى المحاولة مرة أخرى",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
