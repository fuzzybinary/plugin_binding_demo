import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'global_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loadTime = charactersJsonParseTime.inMicroseconds / 1000;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Binding Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Characters JSON loaded in ${loadTime.toStringAsFixed(2)}ms',
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                NavRow(
                  text: 'Method Channles',
                  onTapped: () => context.push('/method_channels'),
                ),
                NavRow(text: 'C FFI', onTapped: () => context.push('/c_ffi')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavRow extends StatelessWidget {
  final String text;
  final VoidCallback? onTapped;

  const NavRow({super.key, required this.text, this.onTapped});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context);
    return InkWell(
      onTap: () => onTapped?.call(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(text, style: style.textTheme.titleLarge),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
