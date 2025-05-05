import 'package:flutter/material.dart';

import 'home_screen.dart';

class BindingDemoApp extends StatelessWidget {
  const BindingDemoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const HomeScreen(),
    );
  }
}
