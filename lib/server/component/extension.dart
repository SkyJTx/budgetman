import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  T? bloc<T extends StateStreamableSource<Object?>>({bool listen = false}) {
    try {
      return BlocProvider.of<T>(this, listen: listen);
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
      return null;
    }
  }

  T? repo<T>({bool listen = false}) {
    try {
      return RepositoryProvider.of<T>(this, listen: listen);
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
      return null;
    }
  }

  Size get size => MediaQuery.sizeOf(this);
}

extension NumX on num {
  num get pi => this * math.pi;
  num get e => this * math.e;
  num pow(num exponent) => math.pow(this, exponent);
  num sqrt() => pow(0.5);
  num cbrt() => pow(1 / 3);
  num abs() => this < 0 ? -this : this;
  num round() => floorToDouble();
  String toShortString({int fractionDigits = 2}) {
    final level = ['', 'K', 'M', 'B', 'T', 'Q'];
    if (this == 0) {
      return 0.toStringAsFixed(fractionDigits);
    }
    final index = (math.log(this.abs()) ~/ math.log(1000)).clamp(0, level.length - 1);
    return '${(this / math.pow(1000, index)).toStringAsFixed(fractionDigits)}${level[index]}';
  }
}

extension Statistic on Iterable<num> {
  num get sum {
    num value = 0;
    for (final e in this) {
      value += e;
    }
    return value;
  }

  num get product {
    num value = 1;
    for (final e in this) {
      value *= e;
    }
    return value;
  }

  num get mean => sum / length;
  num get median => length.isEven
      ? (elementAt((length / 2).floor()) + elementAt((length / 2).ceil())) / 2
      : elementAt((length / 2).floor());
  List<num> get mode {
    final map = <num, int>{};
    for (final e in this) {
      if (map.containsKey(e)) {
        map[e] = map[e]! + 1;
      } else {
        map[e] = 1;
      }
    }
    final max = map.values.max;
    return map.entries.where((element) => element.value == max).map((e) => e.key).toList();
  }

  num get max {
    num value = first;
    for (final e in this) {
      if (e > value) {
        value = e;
      }
    }
    return value;
  }

  num get min {
    num value = first;
    for (final e in this) {
      if (e < value) {
        value = e;
      }
    }
    return value;
  }

  num get pVariance => map((e) => (e - mean).pow(2)).sum / length;
  num get sVariance => map((e) => (e - mean).pow(2)).sum / (length - 1);
  num get pStdDev => pVariance.sqrt();
  num get sStdDev => sVariance.sqrt();
  num get pStdErr => pStdDev / length.sqrt();
  num get sStdErr => sStdDev / length.sqrt();
  num get pSkewness => map((e) => (e - mean).pow(3)).sum / (length * pStdDev.pow(3));
  num get sSkewness => map((e) => (e - mean).pow(3)).sum / ((length - 1) * sStdDev.pow(3));
  num get pKurtosis => map((e) => (e - mean).pow(4)).sum / (length * pStdDev.pow(4));
  num get sKurtosis => map((e) => (e - mean).pow(4)).sum / ((length - 1) * sStdDev.pow(4));
  num get pCV => pStdDev / mean;
  num get sCV => sStdDev / mean;
}

extension BetterIsar on Isar {
  static Isar get instance {
    final isar = Isar.getInstance();
    if (isar == null) {
      throw Exception('Isar instance is null');
    }
    return isar;
  }
}

extension ProperColor on Color {
  Color get invert {
    final luma = 0.2126 * red + 0.7152 * green + 0.0722 * blue;
    return luma > 0.5 ? Colors.black : Colors.white;
  }

  Color get lighten => HSLColor.fromColor(this).withLightness(0.1).toColor();
  Color get darken => HSLColor.fromColor(this).withLightness(-0.1).toColor();
  Color get saturate => HSLColor.fromColor(this).withSaturation(0.1).toColor();
  Color get desaturate => HSLColor.fromColor(this).withSaturation(-0.1).toColor();
  Color get rotate => HSLColor.fromColor(this).withHue(30).toColor();
  Color get complement => HSLColor.fromColor(this).withHue(180).toColor();
  Color get triad => HSLColor.fromColor(this).withHue(120).toColor();
  Color get tetrad => HSLColor.fromColor(this).withHue(90).toColor();
  Color get splitComplement => HSLColor.fromColor(this).withHue(150).toColor();
  Color get analogous => HSLColor.fromColor(this).withHue(30).toColor();
  Color get monochromatic => HSLColor.fromColor(this).withHue(0).toColor();
}
