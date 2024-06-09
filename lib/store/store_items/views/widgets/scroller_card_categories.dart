import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../cubit/categories_cubit.dart';

class ScrollerCardCategorise extends StatelessWidget {
  const ScrollerCardCategorise({super.key,  this.category, this.product});

  final CategoryModel? category;
  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      onTap: () async {
        if (product == null) {
          await Navigator.pushNamed(
            context,
            "Catalog",
            arguments: category,
          );
          return;
        }
      },
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      product == null
                          ? category?.imageUrl ?? ""
                          : product!.imageUrl[0],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    product == null
                        ? category?.name ?? ""
                        : "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
