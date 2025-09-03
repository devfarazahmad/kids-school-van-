import 'package:flutter/material.dart';
import 'parent_login.dart';
import 'parent_signup.dart';

class ParentAuth extends StatelessWidget {
  const ParentAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Auth")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ParentLogin())),
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ParentSignup())),
              child: const Text("Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
