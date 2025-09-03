import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'driver_login.dart';

class DriverSignup extends StatefulWidget {
  const DriverSignup({super.key});

  @override
  State<DriverSignup> createState() => _DriverSignupState();
}

class _DriverSignupState extends State<DriverSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final vehicleController = TextEditingController();
  final phoneController = TextEditingController();

  Future signup() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore
          .collection("drivers")
          .doc(userCredential.user!.uid)
          .set({
        "email": emailController.text.trim(),
        "username": usernameController.text.trim(),
        "vehicle": vehicleController.text.trim(),
        "phone": phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful, Please Login")),
      );

      // Navigate to login screen after signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DriverLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Signup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: vehicleController,
              decoration: const InputDecoration(labelText: "Vehicle Number"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signup, child: const Text("Signup")),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverLogin()),
                );
              },
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
