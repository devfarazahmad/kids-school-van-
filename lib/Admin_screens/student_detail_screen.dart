import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  Future<void> _addDueDialog(DocumentSnapshot doc) async {
    final monthController = TextEditingController();
    final amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Due"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: monthController,
              decoration: const InputDecoration(labelText: "Month (e.g., January)"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount (PKR)"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final data = doc.data() as Map<String, dynamic>;
              final List<Map<String, dynamic>> dues = [];

              // Safely parse existing dues
              if (data['dues'] is List) {
                for (var d in (data['dues'] as List)) {
                  if (d is Map<String, dynamic>) dues.add(d);
                }
              }

              // Add new due
              dues.add({
                "month": monthController.text.trim(),
                "amount": int.tryParse(amountController.text.trim()) ?? 0,
              });

              await studentsCollection.doc(doc.id).update({"dues": dues});
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _clearDue(DocumentSnapshot doc, int index) async {
    final data = doc.data() as Map<String, dynamic>;
    final List<Map<String, dynamic>> dues = [];

    if (data['dues'] is List) {
      for (var d in (data['dues'] as List)) {
        if (d is Map<String, dynamic>) dues.add(d);
      }
    }

    if (index < 0 || index >= dues.length) return;
    dues.removeAt(index);
    await studentsCollection.doc(doc.id).update({"dues": dues});
  }

  Future<void> _editStudent(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final nameController = TextEditingController(text: data['name'] ?? '');
    final rollController = TextEditingController(text: data['rollNo'] ?? '');
    final classController = TextEditingController(text: data['class'] ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Student"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: "Name"), controller: nameController),
            TextField(decoration: const InputDecoration(labelText: "Roll No"), controller: rollController),
            TextField(decoration: const InputDecoration(labelText: "Class"), controller: classController),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await studentsCollection.doc(doc.id).update({
                "name": nameController.text.trim(),
                "rollNo": rollController.text.trim(),
                "class": classController.text.trim(),
              });
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docRef = studentsCollection.doc(widget.studentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final doc = snapshot.data!;
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'] ?? '';
          final rollNo = data['rollNo'] ?? '';
          final studentClass = data['class'] ?? '';

          // ✅ SAFE dues parsing
          final List<Map<String, dynamic>> dues = [];
          if (data['dues'] is List) {
            for (var d in (data['dues'] as List)) {
              if (d is Map<String, dynamic>) dues.add(d);
            }
          }

          final int totalPending = dues.fold<int>(0, (sum, item) {
            if (item['amount'] is num) {
              return sum + (item['amount'] as num).toInt();
            }
            return sum;
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: dues.isNotEmpty ? Colors.red : Colors.green,
                      child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Roll: $rollNo • Class: $studentClass"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editStudent(doc),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text("Pending Months", style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text("${dues.length}", style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text("Total Pending", style: TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text("Rs.$totalPending", style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Monthly Dues", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _addDueDialog(doc),
                      icon: const Icon(Icons.add, color: Colors.blue),
                      label: const Text("Add Due", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (dues.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("No pending dues 🎉"),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dues.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final item = dues[index];
                      final month = item['month']?.toString() ?? "Month";
                      final amount = item['amount']?.toString() ?? "0";
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: Text(month),
                          subtitle: Text("Amount: Rs.$amount"),
                          trailing: IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            tooltip: "Mark as Paid",
                            onPressed: () => _clearDue(doc, index),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
