// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'parent_login.dart';

// class ParentSignup extends StatefulWidget {
//   const ParentSignup({super.key});

//   @override
//   State<ParentSignup> createState() => _ParentSignupState();
// }

// class _ParentSignupState extends State<ParentSignup> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   final emailController = TextEditingController();
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final locationController = TextEditingController();
//   final phoneController = TextEditingController();

//   Future signup() async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       await _firestore.collection("parents").doc(userCredential.user!.uid).set({
//         "email": emailController.text.trim(),
//         "username": usernameController.text.trim(),
//         "location": locationController.text.trim(),
//         "phone": phoneController.text.trim(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Signup Successful")),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const ParentLogin()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   /// Reusable styled TextField
//   Widget buildTextField({
//     required String label,
//     required IconData icon,
//     required TextEditingController controller,
//     bool obscure = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.deepPurple),
//           labelText: label,
//           filled: true,
//             fillColor: const Color.fromARGB(255, 232, 220, 253),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide:
//                 BorderSide(color: Colors.deepPurple.shade200, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: const BorderSide(color: Colors.red, width: 1.5),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: const BorderSide(color: Colors.red, width: 2),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: const Text("Parent Signup", style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 30),
//             Icon(Icons.family_restroom,
//                 size: 100, color: Colors.deepPurple.shade400),
//             const SizedBox(height: 10),
//             Text(
//               "Create Parent Account",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple.shade700,
//               ),
//             ),
//             const SizedBox(height: 30),

//             /// Input Fields
//             buildTextField(
//                 label: "Email", icon: Icons.email, controller: emailController),
//             buildTextField(
//                 label: "Username",
//                 icon: Icons.person,
//                 controller: usernameController),
//             buildTextField(
//                 label: "Password",
//                 icon: Icons.lock,
//                 controller: passwordController,
//                 obscure: true),
//             buildTextField(
//                 label: "Location",
//                 icon: Icons.location_on,
//                 controller: locationController),
//             buildTextField(
//                 label: "Phone Number",
//                 icon: Icons.phone,
//                 controller: phoneController),

//             const SizedBox(height: 20),

//             /// Signup Button
//             ElevatedButton(
//               onPressed: signup,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 minimumSize: const Size(double.infinity, 55),
//               ),
//               child: const Text(
//                 "Signup",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ),

//             const SizedBox(height: 15),

//             /// Switch to Login
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ParentLogin()),
//                 );
//               },
//               child: const Text(
//                 "Already have an account? Log in",
//                 style: TextStyle(
//                   color: Colors.deepPurple,
//                   fontWeight: FontWeight.w600,
                  
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kids_van/screens/services/srvices_images.dart'; // ImgBB service
import 'parent_login.dart';

class ParentSignup extends StatefulWidget {
  const ParentSignup({super.key});

  @override
  State<ParentSignup> createState() => _ParentSignupState();
}

class _ParentSignupState extends State<ParentSignup> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
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

      await _firestore.collection("parents").doc(userCredential.user!.uid).set({
        "email": emailController.text.trim(),
        "username": usernameController.text.trim(),
        "password": passwordController.text.trim(), // optional: if needed
        "location": locationController.text.trim(),
        "phone": phoneController.text.trim(),
        "profileImage": imageUrl ?? "",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentLogin()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// Reusable validated TextFormField
  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: inputType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          filled: true,
          fillColor: const Color.fromARGB(255, 232, 220, 253),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Colors.deepPurple.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text(
          "Parent Signup",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(Icons.family_restroom,
                  size: 100, color: Colors.deepPurple.shade400),
              const SizedBox(height: 10),
              Text(
                "Create Parent Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 30),

              /// Input Fields
              buildTextField(
                label: "Email",
                icon: Icons.email,
                controller: emailController,
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
              buildTextField(
                label: "Username",
                icon: Icons.person,
                controller: usernameController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter username" : null,
              ),
              buildTextField(
                label: "Password",
                icon: Icons.lock,
                controller: passwordController,
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
              buildTextField(
                label: "Location",
                icon: Icons.location_on,
                controller: locationController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter location" : null,
              ),
              buildTextField(
                label: "Phone Number",
                icon: Icons.phone,
                controller: phoneController,
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

              /// Signup Button
              ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(double.infinity, 55),
                ),
                child: const Text(
                  "Signup",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),

              const SizedBox(height: 15),

              /// Switch to Login
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ParentLogin()),
                  );
                },
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

