import 'package:flutter/material.dart';

import '../metric.dart';

class PerformanceTable extends StatelessWidget {
  final List<Metric> metrics;

  const PerformanceTable({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableHeaderStyle = theme.textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.blueGrey.shade200),
          children: [
            Container(),
            Text('Min', style: tableHeaderStyle, textAlign: TextAlign.right),
            Text('Max', style: tableHeaderStyle, textAlign: TextAlign.right),
            Text('Avg', style: tableHeaderStyle, textAlign: TextAlign.right),
          ],
        ),
        for (final m in metrics) _metricRow(m),
      ],
    );
  }

  TableRow _metricRow(Metric metric) {
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
}
