import 'package:flutter/material.dart';
import 'admin_login.dart';
import 'admin_signup.dart';

class AdminAuth extends StatelessWidget {
  const AdminAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Auth")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminLogin()),
              ),
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminSignup()),
              ),
              child: const Text("Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
