


import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.widthFactor = 3,
    this.leftPositionValue = 5,
    this.isWishList = false,
  });

  final ProductModel product;
  final double widthFactor;
  final double leftPositionValue;
  final bool isWishList;

  @override
  Widget build(BuildContext context) {
    final double widthValue = MediaQuery.of(context).size.width / 3;
    final double heightValue = MediaQuery.of(context).size.height / 8;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.pushNamed(
          context,
          "ProductDetails",
          arguments: product,
        );
      },
      child: SizedBox(
        child: Card(
          elevation: 2,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: heightValue,
                child: Card(
                  elevation: .5,
                  margin: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                width: widthValue *4, // Adjust as needed
                                height: heightValue*5 , // Adjust as needed
                                child: PhotoView(
                                  imageProvider: NetworkImage(product.imageUrl[0]),
                                  minScale: PhotoViewComputedScale.contained * 0.8,
                                  maxScale: PhotoViewComputedScale.covered * 2.0,
                                  initialScale: PhotoViewComputedScale.contained,
                                  backgroundDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),

                                ),
                              ),
                            );
                          },
                        );
                      },

                      child: Image.network(
                        width: widthValue,
                        height: heightValue / 1.5,
                        product.imageUrl[0],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            EvaIcons.imageOutline,
                            color: ColorConstant.bgColor,
                          );
                        },

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: widthValue,
                height: heightValue / 1.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        product.name,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Price : ${product.price}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: widthValue,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CartIcon(product: product),
                          if (!isWishList)
                            WishListIcon(product: product),
                        ],
                      ),
                    ),
                    if (isWishList)
                      WishListRemoveIcon(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartIcon extends StatelessWidget {
  const CartIcon({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final isInCart = state is CartLoaded &&
            state.cartItems.any((element) => element.productID == product.productID);
        return IconButton(
          onPressed: ()
          {
            (isInCart)
                ? context.read<CartCubit>().removeFromCart(product: product)
                : context.read<CartCubit>().addToFireStoreCart(product: product);
          },
          icon: Icon(
            isInCart ? EvaIcons.shoppingCart : EvaIcons.shoppingCartOutline,
            color: (isInCart ? Colors.red : ColorConstant.bgColor)
          ),
        );
      },
    );
  }
}

class WishListIcon extends StatelessWidget {
  const WishListIcon({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        final isInWishList = state is WishListLoaded &&
            state.wishListItems.any((element) =>  element.productID == product.productID);
        return IconButton(
          onPressed: () {
            (isInWishList)
                ? context.read<WishListCubit>().removeFromWishList(product: product)
                : context.read<WishListCubit>().addToFireStoreWishList(product: product);
          },
          icon: Icon(
            isInWishList ? EvaIcons.heart : EvaIcons.heartOutline,
            color: (isInWishList)? Colors.red : Colors.black
          ),
        );
      },
    );
  }
}

class WishListRemoveIcon extends StatelessWidget {
  const WishListRemoveIcon({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        return Expanded(
          child: IconButton(
            onPressed: () async {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    backgroundColor:ColorConstant.bgColor,
                    title: const Text('Remove from Favourite?' , style: TextStyle(
                        color: Colors.white,
                      fontSize: 20,
                    ),),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red,
                        )   ,
                        onPressed: () {
                          context.read<WishListCubit>().removeFromWishList(product: product);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              EvaIcons.trash,
              color: ColorConstant.red,
            ),
          ),
        );
      },
    );
  }
}
