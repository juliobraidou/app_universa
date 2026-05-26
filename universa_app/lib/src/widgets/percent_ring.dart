import 'package:flutter/material.dart';

/// Anel de progresso circular que ocupa todo o [size] informado.
class PercentRing extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double size;
  final double strokeWidth;
  final Widget center;

  const PercentRing({
    super.key,
    required this.value,
    required this.color,
    required this.backgroundColor,
    required this.size,
    required this.center,
    this.strokeWidth = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: backgroundColor,
              color: color,
            ),
          ),
          center,
        ],
      ),
    );
  }
}
