import 'package:anwer_shop/core/colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/cubit/cart_cubit.dart';
import 'widgets/wishlist_view_body.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

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
          icon: const Icon(EvaIcons.arrowBack,color: Colors.white),
        ),
        backgroundColor: ColorConstant.bgColor,
        title: const Text(
          "Favorite Items",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorConstant.bgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              icon: const Icon(
                EvaIcons.arrowBack,
                color: Colors.white,
              ),
            ),
            Badge(
              label: StreamBuilder(
                  stream: context.read<CartCubit>().numberOfOrdersInCart(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  }
              ),
              child: IconButton(
                icon: const Icon(
                  EvaIcons.shoppingCartOutline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'CartView',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: const WishListViewBody(),
    );
  }
}
