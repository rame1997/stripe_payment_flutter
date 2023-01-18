import 'package:flutter/material.dart';
import 'package:stripe_payment_ndc/screens/cards_screen.dart';
import 'package:stripe_payment_ndc/screens/launch_screen.dart';
import 'package:stripe_payment_ndc/screens/options_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen': (context) => const LaunchScreen(),
        '/options_screen': (context) => const OptionsScreen(),
        '/cards_screen': (context) => const CardsScreen(),
      },
    );
  }
}