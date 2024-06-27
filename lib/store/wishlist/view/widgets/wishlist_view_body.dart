
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/store_items/views/widgets/product_card.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class WishListViewBody extends StatelessWidget {
  const WishListViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListCubit, WishListState>(
      builder: (context, state) {
        if (state is WishListLoading) {
          return Center(
              child: loadingIndicator(
                color: Colors.white,
              ));

        }
        if (state is WishListLoaded) {
          if (state.wishListItems.isEmpty) {
            return  Center(
                child: SvgPicture.asset('assets/empty.svg',width: 200, height: 200

                  ,));
          }else{
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .65),
            itemCount: state.wishListItems.length,
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ProductCard(
                    isWishList: true,
                    product: state.wishListItems[index],
                    widthFactor: 1.1,
                    leftPositionValue: 120,
                  ),
                ),
              );
            },
          );
        }
        } else if (state is WishListError) {
          return Center(child: Text(state.message));
        } else {
          return Center(
              child: loadingIndicator(
                color: Colors.white,
              ));
        }
      },
    );
  }
}
