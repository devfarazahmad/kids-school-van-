import 'package:flutter/material.dart';
import 'package:kids_van/screens/driver_login.dart';
import 'package:kids_van/screens/driver_signup.dart';


class DriverAuth extends StatelessWidget {
  const DriverAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Auth")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DriverLogin()),
              ),
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DriverSignup()),
              ),
              child: const Text("Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
