import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/store_items/views/widgets/custom_nav_app_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../store_items/cubit/categories_cubit.dart';
import 'widgets/catalog_view_body.dart';

class CatalogView extends StatelessWidget {
   const CatalogView({super.key, required this.category});
   final CategoryModel category;
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
        title:  Text(
          category.name,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomNavAppBar(),
      body:  CatalogViewBody(category: category ,),
      );
  }
}
