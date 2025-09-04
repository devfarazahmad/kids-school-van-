import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _hoursController = TextEditingController();

  // Save schedule to Firebase
  Future<void> _saveSchedule(DateTime date, String hours) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("schedules")
        .doc(user.uid)
        .collection("userSchedules")
        .doc(date.toIso8601String().split("T")[0]) // Save per day
        .set({
      "date": date,
      "hours": hours,
      "createdAt": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Schedule saved successfully!")),
    );
  }

  // Get schedules from Firebase
  Stream<Map<String, dynamic>> _getSchedules() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("schedules")
        .doc(user.uid)
        .collection("userSchedules")
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> events = {};
      for (var doc in snapshot.docs) {
        events[doc.id] = doc.data();
      }
      return events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Schedule",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _getSchedules(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    // Show saved schedule if exists
                    final dateKey = selectedDay.toIso8601String().split("T")[0];
                    final schedule = events[dateKey];
                    if (schedule != null) {
                      _hoursController.text = schedule["hours"];
                    } else {
                      _hoursController.clear();
                    }
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, _) {
                      final dateKey = date.toIso8601String().split("T")[0];
                      if (events.containsKey(dateKey)) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (_selectedDay != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _hoursController,
                          decoration: const InputDecoration(
                            labelText: "Enter working hours (e.g., 9 AM - 2 PM)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (_hoursController.text.isNotEmpty) {
                              await _saveSchedule(
                                  _selectedDay!, _hoursController.text);
                            }
                          },
                          child: const Text("Save Schedule"),
                           style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // 👇 New "View Schedule" button
                        ElevatedButton.icon(
                          //icon: const Icon(Icons.list),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewScheduleScreen(),
                              ),
                            );
                          },
                          label: const Text("View My Schedules"),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
