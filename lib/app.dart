import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'c_ffi/c_ffi_screen.dart';
import 'home_screen.dart';
import 'method_channels/method_channels_screen.dart';
import 'method_channels/open_cv_method_channels_screen.dart';

class BindingDemoApp extends StatelessWidget {
  BindingDemoApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
      GoRoute(
        path: '/method_channels',
        builder: (context, state) => MethodChannelsScreen(),
      ),
      GoRoute(
        path: '/open_cv_method_channels',
        builder: (context, state) => OpenCvMethodChannelsScreen(),
      ),
      GoRoute(path: '/c_ffi', builder: (context, state) => CFfiScreen()),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Performance Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      routerConfig: _router,
    );
  }
}
