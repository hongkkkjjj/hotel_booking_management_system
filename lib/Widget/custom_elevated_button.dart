import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  const CustomElevatedButton({super.key,
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: backgroundColor,
        foregroundColor: calculateForegroundColor(backgroundColor),
      ),
    );
  }

  Color? calculateForegroundColor(Color? backgroundColor) {
    if (backgroundColor == null) {
      return null;
    }

    // Calculate the luminance of the background color
    final double luminance = backgroundColor.computeLuminance();

    // Determine the contrasting foreground color
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
