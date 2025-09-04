import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_van/Admin_screens/inventory_screen.dart';
import 'package:kids_van/Admin_screens/payments_screen.dart';
import 'package:kids_van/Admin_screens/queries_screen.dart';
import 'package:kids_van/Admin_screens/staff_screen.dart';
import 'package:kids_van/Admin_screens/students_screen.dart';
import '../screens/admin_login.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  // Feature items for the grid
  final List<Map<String, dynamic>> _features = const [
    {"title": "Staff", "icon": Icons.people, "color": Colors.deepPurple},
    {"title": "Students", "icon": Icons.school, "color": Colors.blue},
    {"title": "Payments", "icon": Icons.payment, "color": Colors.green},
    {"title": "Queries", "icon": Icons.question_answer, "color": Colors.orange},
    {"title": "Inventory", "icon": Icons.inventory, "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard" , style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminLogin()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // two per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final feature = _features[index];

            return InkWell(
              onTap: () {
                // Navigate to respective screens
                switch (feature['title']) {
                  case "Staff":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const StaffScreen()));
                    break;
                  case "Students":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const StudentsScreen()));
                    break;
                  case "Payments":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PaymentsScreen()));
                    break;
                  case "Queries":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const QueriesScreen()));
                    break;
                  case "Inventory":
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const InventoryScreen()));
                    break;
                }
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: feature['color'].withOpacity(0.85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(feature['icon'], size: 50, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      feature['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
