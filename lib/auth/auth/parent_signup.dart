import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parent_login.dart'; // Import login screen

class ParentSignup extends StatefulWidget {
  const ParentSignup({super.key});

  @override
  State<ParentSignup> createState() => _ParentSignupState();
}

class _ParentSignupState extends State<ParentSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();

  Future signup() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore
          .collection("parents")
          .doc(userCredential.user!.uid)
          .set({
        "email": emailController.text.trim(),
        "username": usernameController.text.trim(),
        "location": locationController.text.trim(),
        "phone": phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Signup Successful")));

      // After signup → move to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Signup")),
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
              controller: locationController,
              decoration: const InputDecoration(labelText: "Location"),
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
                  MaterialPageRoute(builder: (context) => const ParentLogin()),
                );
              },
              child: const Text(
                "Already have an account? Log in",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
