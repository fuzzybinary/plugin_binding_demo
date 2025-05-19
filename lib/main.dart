import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'global_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final stopwatch = Stopwatch();

  final charactersJsonString = await rootBundle.loadString(
    'assets/full_characters.json',
  );

  stopwatch.start();
  rnmCharacters = json.decode(charactersJsonString) as List;
  stopwatch.stop();
  charactersJsonParseTime = stopwatch.elapsed;

  runApp(BindingDemoApp());
}
