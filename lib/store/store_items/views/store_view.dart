import 'package:anwer_shop/store/search/view/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:anwer_shop/store/my_orders/my_orders.dart';
import 'package:anwer_shop/store/setting/views/setting_screen.dart';
import 'package:anwer_shop/store/store_items/cubit/store_items_cubit.dart';
import 'package:anwer_shop/store/store_items/cubit/user_info_cubit.dart';
import 'package:anwer_shop/store/store_items/views/widgets/drawer_item.dart';
import 'package:anwer_shop/store/wishlist/view/wishlist_view.dart';

import '../../cart/cubit/cart_cubit.dart';
import '../../wishlist/cubit/wish_list_cubit.dart';
import 'widgets/store_view_body.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _advancedDrawerController = AdvancedDrawerController();

  final List<Widget> _screens = [
    const StoreViewBody(),
    const WishListView(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, userInfoState) {
        return AdvancedDrawer(
          backdropColor: ColorConstant.primaryColor,
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer: SafeArea(
            child: ListTileTheme(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 128.0,
                        height: 70.0,
                        margin: const EdgeInsets.only(
                          top: 30.0,
                          bottom: 30.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: userInfoState is ImageLoading
                            ? loadingIndicator()
                            : userInfoState is ImageLoaded
                            ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth
                                .instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error: ');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return loadingIndicator(
                                  color: Colors.white,
                                );
                              }
                              final userData = snapshot.data!.data()
                              as Map<String, dynamic>;
                              return Image.network(
                                  userData['profilePicture']);
                            })
                            : Image.asset('assets/user.png'),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  DrawerItem(
                    icon: EvaIcons.home,
                    title: "الرئيسية",
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                  ),
                  DrawerItem(
                    icon: EvaIcons.calendar,
                    title: "طلباتي",
                    onTap: () => Navigator.pushNamed(context, "MyOrders"),
                  ),
                  DrawerItem(
                    icon: EvaIcons.logOut,
                    title: 'تسجيل الخروج',
                    onTap: () async {
                      // Show confirmation dialog
                      await showDialog(
                        barrierDismissible: false,
                        barrierColor: Colors.black.withOpacity(0.5),
                        barrierLabel: 'تسجيل الخروج',
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: ColorConstant.bgColor,
                            shadowColor: ColorConstant.primaryColor,
                            surfaceTintColor: ColorConstant.primaryColor,
                            scrollable: true,
                            semanticLabel: 'تسجيل الخروج',
                            title: const Text('تسجيل الخروج',
                                style: TextStyle(color: Colors.white)),
                            content: const Text('هل تريد تسجيل الخروج؟',
                                style: TextStyle(color: Colors.white)),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("الغاء",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Dismiss the dialog
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('تسجيل الخروج',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  // Perform logout action
                                  Navigator.of(ctx).pop(); // Dismiss the dialog
                                  BlocProvider.of<UserInfoCubit>(context)
                                      .logout();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          rtlOpening: true,
          child: Scaffold(
            backgroundColor: ColorConstant.bgColor,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ColorConstant.bgColor,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarIconBrightness: Brightness.light,
                systemNavigationBarDividerColor: ColorConstant.bgColor,
                systemNavigationBarColor: ColorConstant.bgColor,
                systemStatusBarContrastEnforced: true,
                statusBarBrightness: Brightness.light,
                systemNavigationBarContrastEnforced: true,
              ),
              backgroundColor: ColorConstant.bgColor,
              title: const Center(
                child: Text(
                  'المتجر',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0,top: 10),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, 'CartView');
                  },
                  child: StreamBuilder(
                      stream: context.read<CartCubit>().numberOfOrdersInCart(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data > 0) {
                          return Badge(
                            label: Text(
                              snapshot.data.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            child: Icon(
                              EvaIcons.shoppingCartOutline,
                              color: ColorConstant.whiteA700,
                              size: 30,
                            ),
                          );
                        } else {
                          return Icon(
                            EvaIcons.shoppingCartOutline,
                            color: ColorConstant.red,
                            size: 25,
                          );
                        }
                      }),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                  icon: const Icon(
                    EvaIcons.searchOutline,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    _advancedDrawerController.showDrawer();
                  },
                  icon: const Icon(
                    EvaIcons.menu2Outline,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BlocBuilder<StoreItemsCubit, StoreItemsState>(
              builder: (context, state) {
                return BottomNavigationBar(
                  currentIndex: state.currentIndex ?? 0,
                  onTap: (index) {
                    context.read<StoreItemsCubit>().changeScreen(index);
                  },
                  selectedItemColor: ColorConstant.whiteA700,
                  unselectedItemColor: Colors.white.withOpacity(0.5),
                  backgroundColor: ColorConstant.primaryColor,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'الرئيسية',
                    ),
                    BottomNavigationBarItem(
                      icon: StreamBuilder(
                          stream: context
                              .read<WishListCubit>()
                              .numberOfOrdersInCart(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data > 0) {
                              return Badge(
                                label: Text(
                                  snapshot.data.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                child: const Icon(
                                  EvaIcons.heartOutline,
                                  size: 25,
                                ),
                              );
                            } else {
                              return Icon(
                                EvaIcons.heartOutline,
                                color: ColorConstant.red,
                                size: 25,
                              );
                            }
                          }),
                      label: 'المفضلة',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.settings_outlined),
                      label: "الاعدادات",
                    ),
                  ],
                );
              },
            ),
            body: BlocBuilder<StoreItemsCubit, StoreItemsState>(
              builder: (context, state) {
                return _screens[state.currentIndex ?? 0];
              },
            ),
          ),
        );
      },
    );
  }
}
