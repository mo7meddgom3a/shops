import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final TextStyle? style;
  final double? size;

  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.style,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,  // Setting the text direction to right-to-left
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color ?? Colors.white, size: size ?? 20),
        title: Text(title, style: style ?? const TextStyle(color: Colors.white)),
      ),
    );
  }
}
