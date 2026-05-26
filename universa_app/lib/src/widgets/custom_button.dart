import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final String variant;
  final Color color;
  final Color titleColor;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.color,
    required this.titleColor,
    this.variant = 'primary',
  });

  Map<String, dynamic> get _variantStyle {
    if (variant == 'secondary') {
      return {
        'backgroundColor': Colors.transparent,
        'textColor': titleColor,
        'borderWidth': 1.0,
        'borderRadius': 6.0,
        'borderColor': titleColor,
      };
    }
    return {
      'backgroundColor': color,
      'textColor': titleColor,
      'borderWidth': 1.0,
      'borderRadius': 6.0,
      'borderColor': color,
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = _variantStyle;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: style['backgroundColor'] as Color,
        foregroundColor: style['textColor'] as Color,
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(
          color: style['borderColor'] as Color,
          width: style['borderWidth'] as double,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style['borderRadius'] as double),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
