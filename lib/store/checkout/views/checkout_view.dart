import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/checkout/cubit/place_order_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../store_items/models/product_model.dart';
import 'widgets/checkout_view_body.dart';

class CheckOutView extends StatelessWidget {
  const CheckOutView({super.key, required this.product});

  final List<ProductModel> product;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlaceOrderCubit()..placeOrder(product: product)),
        BlocProvider(create: (context) => PlaceOrderCubit()..fetchCartItems()),


      ],
      child: Scaffold(
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
            icon: const Icon(EvaIcons.arrowBack,
                color: Colors.white),
          ),
          backgroundColor: ColorConstant.bgColor,
          title: const Center(
            child: Text(
              'الطلب',
              style:  TextStyle(color: Colors.white),
            ),
          ),
        ),
        body:  CheckOutViewBody(),
      ),
    );
  }
}
