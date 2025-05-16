import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global_data.dart';
import '../metric.dart';

class MethodChannelsScreen extends StatefulWidget {
  const MethodChannelsScreen({super.key});

  @override
  State<MethodChannelsScreen> createState() => _MethodChannelsScreenState();
}

class _MethodChannelsScreenState extends State<MethodChannelsScreen> {
  static const totalIterations = 50;
  static const methodChannel = MethodChannel('fuzzybinary.binding_demo');

  final Metric callMetric = Metric('Call Time');
  final Metric fullResponse = Metric('Full Time');

  bool _runningTest = false;
  int _iterations = 0;

  void _runTest() async {
    setState(() {
      callMetric.reset();
      fullResponse.reset();

      _runningTest = true;
      _iterations = 0;
    });

    for (int i = 0; i < totalIterations; ++i) {
      final stopwatch = Stopwatch();
      stopwatch.start();

      final future = methodChannel.invokeMethod('methodCallChannelTest', {
        'characters': rnmCharacters,
      });
      callMetric.addSample(stopwatch.elapsedMicroseconds / 1000);
      await future.then((_) {
        fullResponse.addSample(stopwatch.elapsedMicroseconds / 1000);
      });

      setState(() {
        _iterations++;
      });
    }

    setState(() {
      _runningTest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableHeaderStyle = theme.textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Method Channels'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Text('Iterations: $_iterations'),
            Table(
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blueGrey.shade200),
                  children: [
                    Container(),
                    Text(
                      'Min',
                      style: tableHeaderStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'Max',
                      style: tableHeaderStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'Avg',
                      style: tableHeaderStyle,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                metricRow(callMetric),
                metricRow(fullResponse),
              ],
            ),
            ElevatedButton(
              onPressed: _runningTest ? null : _runTest,
              child: Text('Run Experiment'),
            ),
          ],
        ),
      ),
    );
  }
}

TableRow metricRow(Metric metric) {
  return TableRow(
    children: [
      Text('${metric.name}:'),
      Text(
        '${metric.minValue.toStringAsFixed(2)}ms',
        textAlign: TextAlign.right,
      ),
      Text(
        '${metric.maxValue.toStringAsFixed(2)}ms',
        textAlign: TextAlign.right,
      ),
      Text(
        '${metric.avgValue.toStringAsFixed(2)}ms',
        textAlign: TextAlign.right,
      ),
    ],
  );
}
