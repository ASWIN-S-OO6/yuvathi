import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    Key? key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              colors ??
              [
                Colors.white,
                const Color(0xFFF8BBD0), // Colors.pink[200]
              ],
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
