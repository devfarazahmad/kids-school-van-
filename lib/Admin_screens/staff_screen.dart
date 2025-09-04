import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kids_van/Admin_screens/StaffDetailScreen';
// <-- new screen

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final CollectionReference staffCollection =
      FirebaseFirestore.instance.collection('staff');

  // ------------------ ADD / EDIT STAFF ------------------
  Future<void> _showStaffDialog({DocumentSnapshot? doc}) async {
    final isEditing = doc != null;
    final data = doc?.data() as Map<String, dynamic>? ?? {};

    final nameController = TextEditingController(text: data['name'] ?? '');
    final roleController = TextEditingController(text: data['role'] ?? '');
    final phoneController = TextEditingController(text: data['phone'] ?? '');
    final salaryController =
        TextEditingController(text: (data['salary'] ?? '').toString());
    final emailController = TextEditingController(text: data['email'] ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? "Edit Staff" : "Add Staff"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: roleController, decoration: const InputDecoration(labelText: "Role")),
              TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone")),
              TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: salaryController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Salary (PKR)")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final staffData = {
                "name": nameController.text.trim(),
                "role": roleController.text.trim(),
                "phone": phoneController.text.trim(),
                "email": emailController.text.trim(),
                "salary": int.tryParse(salaryController.text.trim()) ?? 0,
                "createdAt": FieldValue.serverTimestamp(),
              };

              if (isEditing) {
                await staffCollection.doc(doc!.id).update(staffData);
              } else {
                await staffCollection.add(staffData);
              }

              if (mounted) Navigator.pop(context);
            },
            child: Text(isEditing ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }

  // ------------------ DELETE STAFF ------------------
  Future<void> _deleteStaff(String id) async {
    await staffCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Staff", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: staffCollection.orderBy("createdAt", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading staff"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final staffDocs = snapshot.data!.docs;

          if (staffDocs.isEmpty) {
            return const Center(child: Text("No staff added yet."));
          }

          return ListView.builder(
            itemCount: staffDocs.length,
            itemBuilder: (context, index) {
              final doc = staffDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 187, 166, 223),
                    child: Text(data['name'] != null && data['name'].isNotEmpty
                        ? data['name'][0].toUpperCase()
                        : "?"),
                  ),
                  title: Text(data['name'] ?? "Unknown"),
                  subtitle: Text("${data['role'] ?? ''}\n${data['phone'] ?? ''}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StaffDetailScreen(staffId: doc.id),
                      ),
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "edit") {
                        _showStaffDialog(doc: doc);
                      } else if (value == "delete") {
                        _deleteStaff(doc.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "edit", child: Text("Edit")),
                      const PopupMenuItem(value: "delete", child: Text("Delete")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 160, 136, 200),
        onPressed: () => _showStaffDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
