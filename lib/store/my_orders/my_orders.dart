import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/my_orders/cubit/my_orders_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/customordersview.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit()..fetchUserOrders(),
      child: Scaffold(
          backgroundColor: ColorConstant.bgColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                EvaIcons.arrowBack,
                color: Colors.white,
              ),
            ),
            backgroundColor: ColorConstant.bgColor,
            title: const Text(
              'My Orders',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<OrdersCubit, OrdersState>(
                      builder: (context, state) {
                        if (state is OrdersLoading){
                          return Center(
                              child: loadingIndicator(
                                color: Colors.white,
                              ));
                        }
                        if (state.orders.isEmpty) {
                          return const Center(
                            child: Text("No Orders Found",style: TextStyle(color: Colors.white),),
                          );
                        } else if (state is OrdersError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: state.orders.length,
                            itemBuilder: (context, index) {
                              return CustomOrdersView(state: state, index: index);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

