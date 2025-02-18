import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/firebase/style_bloc.dart';
import 'features/cart/data/repositories/cart_repository.dart';
import 'features/cart/presentation/blocs/cart_bloc.dart';
import 'features/home/data/repositories/product_repository.dart';
import 'features/home/presentation/blocs/home_bloc.dart';
import 'widgets/bottom_nav_bar_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StyleBloc()..add(FetchStyleEvent()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            productRepository: ProductRepository(),
          )..add(LoadProductsEvent()),
        ),
        BlocProvider(
          create: (context) => CartBloc(
            cartRepository: CartRepository(),
          )..add(LoadCartEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData.light(),
        home: const BottomNavBarApp(),
      ),
    );
  }
}
