import 'package:complete_clean_app/provider/cart_provider.dart';
import 'package:complete_clean_app/provider/product_provider.dart';
import 'package:complete_clean_app/vendor/views/auth/vendor_auth.dart';
import 'package:complete_clean_app/vendor/views/auth/vendor_register_screen.dart';
import 'package:complete_clean_app/vendor/views/screens/vendor_logout_screen.dart';
import 'package:complete_clean_app/views/buyers/auth/login_screen.dart';
import 'package:complete_clean_app/views/buyers/auth/register_screen.dart';
import 'package:complete_clean_app/views/buyers/main_screen.dart';
import 'package:complete_clean_app/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:complete_clean_app/views/buyers/nav_screens/widgets/welcome_text_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'vendor/views/screens/main_vendor_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_){
        return ProductProvider();
      }),

      ChangeNotifierProvider(create: (_){
        return CartProvider();
      })
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}

