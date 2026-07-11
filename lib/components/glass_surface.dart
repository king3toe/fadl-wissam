/// Reusable glassmorphism widget following the exact spec recipe.
/// Blur 20px, saturation 180%, faint coral border, proper shadows.

import 'package:flutter/material.dart';
import '../design/design_tokens.dart';

class GlassSurface extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final BoxConstraints? constraints;
  final List<BoxShadow>? shadows;

  const GlassSurface({
    Key? key,
    required this.child,
    this.radius = RaqimRadius.radiusMd,
    this.padding = const EdgeInsets.all(RaqimSpacing.space4),
    this.constraints,
    this.shadows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final decoration = isDark ? RaqimGlass.glassDark() : RaqimGlass.glassLight();

    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        color: decoration.color,
        borderRadius: BorderRadius.circular(radius),
        border: decoration.border,
        boxShadow: shadows ?? decoration.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
