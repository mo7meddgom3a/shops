import 'package:anwer_shop/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:anwer_shop/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:anwer_shop/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:anwer_shop/auth/firebase_user_repo.dart';
import 'package:anwer_shop/auth/screens/login_screen/login_screen.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/cart/view/cart_view.dart';
import 'package:anwer_shop/store/catalog/view/catalog_view.dart';
import 'package:anwer_shop/store/checkout/views/checkout_view.dart';
import 'package:anwer_shop/store/product_details/views/product_details_view.dart';
import 'package:anwer_shop/store/store_items/cubit/categories_cubit.dart';
import 'package:anwer_shop/store/store_items/cubit/store_items_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:anwer_shop/store/wishlist/view/wishlist_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ShopsApp());
}
class ShopsApp extends StatelessWidget {
  const ShopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartCubit(),
        ),
        BlocProvider(
          create: (context) => StoreItemsCubit(),
        ),
        BlocProvider(
          create: (context) => WishListCubit(),
        ),
        BlocProvider(
          create: (context) => StoreCategoriesCubit(),
        ),BlocProvider(
          create: (context) => SignInBloc(userRepository: FirebaseUserRepo()),
        ),BlocProvider(
          create: (context) => SignUpBloc(userRepository: FirebaseUserRepo()),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc(userRepo: FirebaseUserRepo()),
        ),
      ],
      child: MaterialApp(
        routes: {
          'CartView': (context) => const CartView(),
          "Catalog": (context) => CatalogView(
                category:
                    ModalRoute.of(context)?.settings.arguments as CategoryModel,
              ),
          "ProductDetails": (context) => ProductDetailsView(
                product:
                    ModalRoute.of(context)?.settings.arguments as ProductModel,
              ),
          "WishList": (context) => const WishListView(),
          "Checkout": (context) => CheckOutView(
                product: ModalRoute.of(context)?.settings.arguments
                    as List<ProductModel>,
              ),
        },
        debugShowCheckedModeBanner: false,
        title: 'Shops',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
