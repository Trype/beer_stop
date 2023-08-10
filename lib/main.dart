import 'package:beer_stop/navigation/navigation_data.dart';
import 'package:beer_stop/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(foregroundColor: Colors.black)
      ),
      routerConfig: goRouter,
    );
  }
}
