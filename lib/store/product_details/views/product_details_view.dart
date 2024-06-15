
import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/product_details_view_body.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:Colors.blueGrey,
          systemNavigationBarDividerColor: ColorConstant.primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        title: Text(
          product.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocBuilder<WishListCubit, WishListState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () async{
                    await context
                        .read<WishListCubit>()
                        .addToFireStoreWishList(product: product);
                    if (state is WishListLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ' تمت إضافت ${product.name} إلى قائمة المفضلة',
                          ),
                          duration: const Duration(milliseconds: 200),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.favorite, color:Colors.red,),
                );
              },
            ),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: () async{
                       await context.read<CartCubit>().addToFireStoreCart(
                            product: product,
                          );
                       if (state is CartLoaded) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text(
                               ' تمت إضافة ${product.name} إلى السلة',
                             ),
                             duration: const Duration(milliseconds: 200),
                           ),
                         );
                       }
                    },
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
                    ));
              },
            )
          ],
        ),
      ),
      body: ProductDetailsViewBody(
        product: product,
      ),
    );
  }
}
