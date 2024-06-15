import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/store_items/views/widgets/custom_nav_app_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/cubit/cart_cubit.dart';
import '../../store_items/cubit/categories_cubit.dart';
import 'widgets/catalog_view_body.dart';

class CatalogView extends StatelessWidget {
   const CatalogView({super.key, required this.category});
   final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blueGrey,
          systemNavigationBarDividerColor: ColorConstant.primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(EvaIcons.arrowBack, color: Colors.white),
        ),
        actions: [
          SizedBox(width: 10,),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Badge(
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
                  onPressed: () async {
                    await Navigator.pushNamed(context, 'CartView');
                  },
                  icon: Icon(
                    EvaIcons.shoppingCartOutline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 10,),

        ],
        backgroundColor: Colors.blueGrey,
        title:  Text(
          category.name,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      // bottomNavigationBar: const CustomNavAppBar(),
      body:  CatalogViewBody(category: category ,),
      );
  }
}
