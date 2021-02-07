import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auths.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/edit_products_screen/edit_products_screen.dart';
import 'package:shop_app/screens/login_screen/login_screen.dart';

import 'providers/products.dart';
import 'screens/cart_screen/cart_screen.dart';
import 'screens/orders_screen/order_screen.dart';
import 'screens/product_manager_screen/user_product_screen.dart';
import 'screens/product_overview/product_overview_screen.dart';
import 'screens/product_overview/widget/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Order()),
      ],
      //product thay doi con material khong lien quan
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Happy Shop',
        theme: ThemeData(
          primarySwatch: Colors.pink, //mau chinh
          accentColor: Colors.black, //mau nhan
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthScreen(),
        routes: {
          //Đăng ký các tuyến đường để truyền dữ liệu
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routerName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}
