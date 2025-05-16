import 'dart:math';

class Metric {
  final String name;

  int _numSamples = 0;
  int get numSamples {
    return _numSamples;
  }

  double _minValue = double.infinity;
  double get minValue {
    return _minValue;
  }

  double _maxValue = 0.0;
  double get maxValue {
    return _maxValue;
  }

  double _avgValue = 0.0;
  double get avgValue {
    return _avgValue;
  }

  Metric(this.name);

  void reset() {
    _numSamples = 0;
    _minValue = double.infinity;
    _maxValue = 0.0;
    _avgValue = 0.0;
  }

  void addSample(double value) {
    _minValue = min(_minValue, value);
    _maxValue = max(_maxValue, value);

    _avgValue = (value + (_numSamples * _avgValue)) / (_numSamples + 1);
    _numSamples++;
  }
}
