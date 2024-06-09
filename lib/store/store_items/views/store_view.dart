


import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/cubit/cart_cubit.dart';
import 'widgets/store_view_body.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorConstant.primaryColor,
            systemNavigationBarDividerColor: ColorConstant.primaryColor,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(EvaIcons.arrowBack, color: Colors.white),
          ),
          backgroundColor: ColorConstant.bgColor,
          title: const Text(
            'Store',
            style: TextStyle(color: Colors.white),
          ),

          actions: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, 'CartView');
              },
              child: StreamBuilder(
                  stream: context.read<CartCubit>().numberOfOrdersInCart(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data > 0) {
                      return Badge(
                        label: Text(
                          snapshot.data.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: Icon(
                          EvaIcons.shoppingCartOutline,
                          color: ColorConstant.whiteA700,
                          size: 25,
                        ),
                      );
                    } else {
                      return Icon(
                        EvaIcons.shoppingCartOutline,
                        color: ColorConstant.whiteA700,
                        size: 25,
                      );
                    }
                  }
              ),
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: const StoreViewBody(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0 , right: 10),
          child: FloatingActionButton(

            onPressed: () async {
              // await context.read<WishListCubit>().fetchWishListItems();
              Navigator.pushNamed(context, "WishList");
            },
            elevation: 0, // Remove shadow
            backgroundColor: Colors.transparent, // Remove background color
            child: StreamBuilder(
                stream: context.read<WishListCubit>().numberOfOrdersInCart(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data > 0) {
                    return Badge(
                      label: Text(
                        snapshot.data.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      child: Icon(
                        EvaIcons.heartOutline,
                        color: ColorConstant.whiteA700,
                        size: 25,
                      ),
                    );
                  } else {
                    return Icon(
                      EvaIcons.heart,
                      color: ColorConstant.red,
                      size: 25,
                    );
                  }
                }
            )

          ),
        )
        );
  }
}
