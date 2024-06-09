import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key, required this.title,
  });

  final String title ;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
