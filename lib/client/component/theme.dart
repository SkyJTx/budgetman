import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff296a48),
      surfaceTint: Color(0xff296a48),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffaef2c6),
      onPrimaryContainer: Color(0xff002111),
      secondary: Color(0xff4e6355),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd1e8d6),
      onSecondaryContainer: Color(0xff0c1f14),
      tertiary: Color(0xff3b6471),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbfe9f8),
      onTertiaryContainer: Color(0xff001f27),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfff6fbf4),
      onBackground: Color(0xff171d19),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff171d19),
      surfaceVariant: Color(0xffdce5dc),
      onSurfaceVariant: Color(0xff404942),
      outline: Color(0xff717972),
      outlineVariant: Color(0xffc0c9c0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inverseOnSurface: Color(0xffedf2eb),
      inversePrimary: Color(0xff92d5ab),
      primaryFixed: Color(0xffaef2c6),
      onPrimaryFixed: Color(0xff002111),
      primaryFixedDim: Color(0xff92d5ab),
      onPrimaryFixedVariant: Color(0xff075232),
      secondaryFixed: Color(0xffd1e8d6),
      onSecondaryFixed: Color(0xff0c1f14),
      secondaryFixedDim: Color(0xffb5ccba),
      onSecondaryFixedVariant: Color(0xff374b3e),
      tertiaryFixed: Color(0xffbfe9f8),
      onTertiaryFixed: Color(0xff001f27),
      tertiaryFixedDim: Color(0xffa3cddc),
      onTertiaryFixedVariant: Color(0xff224c58),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffeaefe8),
      surfaceContainerHigh: Color(0xffe4eae3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff004d2e),
      surfaceTint: Color(0xff296a48),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff41815d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff33473a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff647a6a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1d4854),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff527a88),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff6fbf4),
      onBackground: Color(0xff171d19),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff171d19),
      surfaceVariant: Color(0xffdce5dc),
      onSurfaceVariant: Color(0xff3d453e),
      outline: Color(0xff59615a),
      outlineVariant: Color(0xff747d75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inverseOnSurface: Color(0xffedf2eb),
      inversePrimary: Color(0xff92d5ab),
      primaryFixed: Color(0xff41815d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff266845),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff647a6a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4c6152),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff527a88),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff39626e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffeaefe8),
      surfaceContainerHigh: Color(0xffe4eae3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff002916),
      surfaceTint: Color(0xff296a48),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004d2e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff13261b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff33473a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002630),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1d4854),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff6fbf4),
      onBackground: Color(0xff171d19),
      surface: Color(0xfff6fbf4),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffdce5dc),
      onSurfaceVariant: Color(0xff1e2620),
      outline: Color(0xff3d453e),
      outlineVariant: Color(0xff3d453e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322d),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffb7fbcf),
      primaryFixed: Color(0xff004d2e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00341d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff33473a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1d3125),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1d4854),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00323d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff6fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ee),
      surfaceContainer: Color(0xffeaefe8),
      surfaceContainerHigh: Color(0xffe4eae3),
      surfaceContainerHighest: Color(0xffdfe4dd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff92d5ab),
      surfaceTint: Color(0xff92d5ab),
      onPrimary: Color(0xff003920),
      primaryContainer: Color(0xff075232),
      onPrimaryContainer: Color(0xffaef2c6),
      secondary: Color(0xffb5ccba),
      onSecondary: Color(0xff213528),
      secondaryContainer: Color(0xff374b3e),
      onSecondaryContainer: Color(0xffd1e8d6),
      tertiary: Color(0xffa3cddc),
      onTertiary: Color(0xff043541),
      tertiaryContainer: Color(0xff224c58),
      onTertiaryContainer: Color(0xffbfe9f8),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff0f1511),
      onBackground: Color(0xffdfe4dd),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffdfe4dd),
      surfaceVariant: Color(0xff404942),
      onSurfaceVariant: Color(0xffc0c9c0),
      outline: Color(0xff8a938b),
      outlineVariant: Color(0xff404942),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inverseOnSurface: Color(0xff2c322d),
      inversePrimary: Color(0xff296a48),
      primaryFixed: Color(0xffaef2c6),
      onPrimaryFixed: Color(0xff002111),
      primaryFixedDim: Color(0xff92d5ab),
      onPrimaryFixedVariant: Color(0xff075232),
      secondaryFixed: Color(0xffd1e8d6),
      onSecondaryFixed: Color(0xff0c1f14),
      secondaryFixedDim: Color(0xffb5ccba),
      onSecondaryFixedVariant: Color(0xff374b3e),
      tertiaryFixed: Color(0xffbfe9f8),
      onTertiaryFixed: Color(0xff001f27),
      tertiaryFixedDim: Color(0xffa3cddc),
      onTertiaryFixedVariant: Color(0xff224c58),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff313632),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96d9af),
      surfaceTint: Color(0xff92d5ab),
      onPrimary: Color(0xff001b0d),
      primaryContainer: Color(0xff5d9e78),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb9d1bf),
      onSecondary: Color(0xff061a0f),
      secondaryContainer: Color(0xff809686),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa7d1e0),
      onTertiary: Color(0xff001920),
      tertiaryContainer: Color(0xff6e97a5),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff0f1511),
      onBackground: Color(0xffdfe4dd),
      surface: Color(0xff0f1511),
      onSurface: Color(0xfff7fcf5),
      surfaceVariant: Color(0xff404942),
      onSurfaceVariant: Color(0xffc4cdc4),
      outline: Color(0xff9ca59d),
      outlineVariant: Color(0xff7d857e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inverseOnSurface: Color(0xff262b27),
      inversePrimary: Color(0xff0a5333),
      primaryFixed: Color(0xffaef2c6),
      onPrimaryFixed: Color(0xff001509),
      primaryFixedDim: Color(0xff92d5ab),
      onPrimaryFixedVariant: Color(0xff003f24),
      secondaryFixed: Color(0xffd1e8d6),
      onSecondaryFixed: Color(0xff03150a),
      secondaryFixedDim: Color(0xffb5ccba),
      onSecondaryFixedVariant: Color(0xff273b2e),
      tertiaryFixed: Color(0xffbfe9f8),
      onTertiaryFixed: Color(0xff00141a),
      tertiaryFixedDim: Color(0xffa3cddc),
      onTertiaryFixedVariant: Color(0xff0d3b47),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff313632),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffeefff1),
      surfaceTint: Color(0xff92d5ab),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff96d9af),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffeefff1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb9d1bf),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff5fcff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa7d1e0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff0f1511),
      onBackground: Color(0xffdfe4dd),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff404942),
      onSurfaceVariant: Color(0xfff4fdf4),
      outline: Color(0xffc4cdc4),
      outlineVariant: Color(0xffc4cdc4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dd),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff00311b),
      primaryFixed: Color(0xffb2f6ca),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff96d9af),
      onPrimaryFixedVariant: Color(0xff001b0d),
      secondaryFixed: Color(0xffd5edda),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb9d1bf),
      onSecondaryFixedVariant: Color(0xff061a0f),
      tertiaryFixed: Color(0xffc3eefd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa7d1e0),
      onTertiaryFixedVariant: Color(0xff001920),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff313632),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
