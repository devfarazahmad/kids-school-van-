
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kids_van/screens/services/srvices_images.dart'; // ImgBB service
import 'admin_login.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authorityController = TextEditingController();
  final phoneController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Signup
  Future signup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String? imageUrl;
      if (_profileImage != null) {
        final imgbb = ImgBBService();
        final response = await imgbb.uploadImageBase64(
          base64Encode(await _profileImage!.readAsBytes()),
        );

        if (response != null && response["success"]) {
          imageUrl = response["data"]["url"];
        }
      }

      await _firestore.collection("admins").doc(userCredential.user!.uid).set({
        "email": emailController.text.trim(),
        "username": usernameController.text.trim(),
        "authority": authorityController.text.trim(),
        "phone": phoneController.text.trim(),
        "profileImage": imageUrl ?? "",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Custom validated text field
  Widget customTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Admin Signup",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      const SizedBox(height: 10),
                      Icon(Icons.admin_panel_settings,
                          size: 100, color: Colors.deepPurple.shade400),
                      const SizedBox(height: 20),

                      customTextField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          if (!value.contains("@")) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      customTextField(
                        controller: usernameController,
                        label: "Username",
                        icon: Icons.person,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Enter username" : null,
                      ),
                      const SizedBox(height: 15),
                      customTextField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      customTextField(
                        controller: authorityController,
                        label: "Authority",
                        icon: Icons.security,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Enter authority" : null,
                      ),
                      const SizedBox(height: 15),
                      customTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        icon: Icons.phone,
                        inputType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter phone number";
                          }
                          if (value.length < 10) {
                            return "Enter valid phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Profile image upload
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.deepPurple.shade100,
                          backgroundImage:
                              _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null
                              ? const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.deepPurple)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminLogin()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Log in",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

