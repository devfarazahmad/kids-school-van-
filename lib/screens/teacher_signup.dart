
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kids_van/screens/services/srvices_images.dart';
import 'package:kids_van/screens/teacher_login.dart';
import 'driver_login.dart';

class TeacherSignup extends StatefulWidget {
  const TeacherSignup({super.key});

  @override
  State<TeacherSignup> createState() => _DriverSignupState();
}

class _DriverSignupState extends State<TeacherSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final vehicleController = TextEditingController();
  final phoneController = TextEditingController();

  File? _profileImage; // store selected image file
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Signup method with image upload
  Future signup() async {
    try {

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String? imageUrl;
      if (_profileImage != null) {
        
              final imgbb = ImgBBService();


      final response = await imgbb.uploadImageBase64(base64Encode(await _profileImage!.readAsBytes()));

if (response != null && response["success"]) {
  print("Image URL: ${response["data"]["url"]}");
  imageUrl = response["data"]["url"];
  setState(() {
    
  });
} else {
  print("Upload failed");
}

      }

      // Save user data to Firestore
      await _firestore.collection("drivers").doc(userCredential.user!.uid).set({
        "email": emailController.text.trim(),
        "username": usernameController.text.trim(),
        "vehicle": vehicleController.text.trim(),
        "phone": phoneController.text.trim(),
        "profileImage": imageUrl ?? "", // save image URL
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful, Please Login")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TeacherLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget customTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: label,
        filled: true,
        fillColor: const Color.fromARGB(255, 231, 220, 250),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Teacher Signup",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 20),

                    customTextField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    customTextField(
                        controller: usernameController,
                        label: "Username",
                        icon: Icons.person),
                    const SizedBox(height: 15),
                    customTextField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        obscure: true),
                    const SizedBox(height: 15),
                    customTextField(
                        controller: vehicleController,
                        label: "Subject",
                        icon: Icons.book_online),
                    const SizedBox(height: 15),
                    customTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        icon: Icons.phone,
                        inputType: TextInputType.phone),
                    const SizedBox(height: 20),

                
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
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()=> signup(),
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
                              builder: (_) => const DriverLogin()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login",
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
    );
  }
}

