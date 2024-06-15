import 'package:anwer_shop/core/colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/cubit/cart_cubit.dart';

class CustomNavAppBar extends StatelessWidget {
  const CustomNavAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueGrey,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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

        ],
      ),
    );
  }
}
