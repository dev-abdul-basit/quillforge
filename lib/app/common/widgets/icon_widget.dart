import 'package:flutter/cupertino.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.weight,
  });
  final IconData icon;
  final double? size;
  final Color? color;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
      weight: weight,
    );
  }
}
