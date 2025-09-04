import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_detail_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  String searchQuery = "";

  // Add or Edit Student
  void _showStudentDialog({DocumentSnapshot? doc}) {
    final data = (doc?.data() as Map<String, dynamic>?) ?? {};
    final nameController = TextEditingController(text: data['name'] ?? '');
    final rollController = TextEditingController(text: data['rollNo'] ?? '');
    final classController = TextEditingController(text: data['class'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(doc == null ? "Add Student" : "Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: rollController,
                decoration: const InputDecoration(labelText: "Roll No"),
              ),
              TextField(
                controller: classController,
                decoration: const InputDecoration(labelText: "Class"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final studentData = {
                "name": nameController.text.trim(),
                "rollNo": rollController.text.trim(),
                "class": classController.text.trim(),
                // Always store dues as a list
                "dues": (doc == null)
                    ? <Map<String, dynamic>>[]
                    : (data['dues'] is List ? data['dues'] : []),
              };

              if (doc == null) {
                await studentsCollection.add(studentData);
              } else {
                await studentsCollection.doc(doc.id).update(studentData);
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(doc == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  // Delete student
  Future<void> _deleteStudent(String id) async {
    await studentsCollection.doc(id).delete();
  }

  // Search by Roll No only
  void _showSearchDialog() {
    final searchController = TextEditingController(text: searchQuery);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Search Student"),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(labelText: "Enter Roll No"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => searchQuery = searchController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Search"),
          ),
          TextButton(
            onPressed: () {
              setState(() => searchQuery = "");
              Navigator.pop(context);
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Query query = studentsCollection;
    if (searchQuery.isNotEmpty) {
      query = query.where("rollNo", isEqualTo: searchQuery);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Students"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: _showSearchDialog, icon: const Icon(Icons.search)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;
          if (students.isEmpty) {
            return const Center(
              child: Text("No Students Found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            );
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final data = student.data() as Map<String, dynamic>;
              final name = data['name'] ?? '';
              final rollNo = data['rollNo'] ?? '';
              final studentClass = data['class'] ?? '';

              // SAFE dues extraction
              final dynamic duesData = data['dues'] ?? [];
              final List<Map<String, dynamic>> dues = [];

              if (duesData is List) {
                for (var item in duesData) {
                  if (item is Map<String, dynamic>) {
                    dues.add(item);
                  }
                }
              }

              final int pendingMonths = dues.length;
              final int totalPending = dues.fold<int>(0, (sum, item) {
                if (item['amount'] is num) {
                  return sum + (item['amount'] as num).toInt();
                }
                return sum;
              });

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentDetailScreen(studentId: student.id),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor:
                        pendingMonths > 0 ? Colors.red : Colors.green,
                    child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
                  ),
                  title: Text(name),
                  subtitle: Text(
                    "Roll: $rollNo | Class: $studentClass\n"
                    "Pending: $pendingMonths month(s) • Rs.$totalPending",
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showStudentDialog(doc: student),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteStudent(student.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showStudentDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
