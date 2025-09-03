import 'package:flutter/material.dart';
import 'package:kids_van/auth/auth/driver_auth.dart';
import 'package:kids_van/auth/auth/parent_auth.dart';
import 'package:kids_van/screens/admin_auth.dart';
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Your Role",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ParentAuth())),
                child: const Text("Parent"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DriverAuth())),
                child: const Text("Driver"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AdminAuth())),
                child: const Text("Admin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
