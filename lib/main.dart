import 'package:anwer_shop/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:anwer_shop/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:anwer_shop/simple_bloc_observer.dart';
import 'package:anwer_shop/store/cart/cubit/cart_cubit.dart';
import 'package:anwer_shop/store/cart/view/cart_view.dart';
import 'package:anwer_shop/store/catalog/view/catalog_view.dart';
import 'package:anwer_shop/store/checkout/views/checkout_view.dart';
import 'package:anwer_shop/store/product_details/views/product_details_view.dart';
import 'package:anwer_shop/store/store_items/cubit/categories_cubit.dart';
import 'package:anwer_shop/store/store_items/cubit/store_items_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:anwer_shop/store/store_items/views/store_view.dart';
import 'package:anwer_shop/store/wishlist/cubit/wish_list_cubit.dart';
import 'package:anwer_shop/store/wishlist/view/wishlist_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'auth/welcome_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(StoreApp(userRepository: FirebaseUserRepo()));
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key, required this.userRepository});

  final UserRepository userRepository;

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
        ),
        RepositoryProvider(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository),
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
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository),
                child: const StoreView(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}
