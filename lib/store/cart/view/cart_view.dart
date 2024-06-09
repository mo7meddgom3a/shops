import 'package:anwer_shop/core/colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/cart_view_body.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

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
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const CartViewBody(),
    );
  }
}
