import 'package:flutter/material.dart';

class QueriesScreen extends StatelessWidget {
  const QueriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queries"),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          "Queries Screen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
