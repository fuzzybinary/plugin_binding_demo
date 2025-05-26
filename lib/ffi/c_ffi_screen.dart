import 'package:flutter/material.dart';

class CFfiScreen extends StatefulWidget {
  const CFfiScreen({super.key});

  @override
  State<CFfiScreen> createState() => _CFfiScreenState();
}

class _CFfiScreenState extends State<CFfiScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text('C FFI Binding'),
      ),
    );
  }
}
