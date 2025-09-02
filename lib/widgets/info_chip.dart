import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final String label;
  const InfoChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.indigo.shade100,
    );
  }
}
