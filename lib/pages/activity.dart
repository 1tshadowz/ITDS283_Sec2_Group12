import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';
import 'track.dart';
import 'setting.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int selectedIndex = 1;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, dynamic> activityData = {
    'drinking': 0.0,
    'showering': 0,
    'cooking': 0,
    'Toilet': 0,
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDataForDate(_selectedDay!);
  }

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TrackWaterPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AchievementPage(title: "Achievements")));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductPage()));
        break;
    }
  }

  Future<void> _loadDataForDate(DateTime date) async {
    final String formattedDate = DateFormat('d/M/yyyy').format(date);
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('track_usage')
          .where('date', isEqualTo: formattedDate)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double drinkingTotal = 0.0;
        double showeringTotal = 0.0;
        double cookingTotal = 0.0;
        double toiletTotal = 0.0;

        for (var doc in querySnapshot.docs) {
          var docData = doc.data();
          String usage = docData['usage'] ?? '';

          if (usage == 'Drinking') {
            int glasses = int.tryParse(docData['quantity'] ?? '0') ?? 0;
            drinkingTotal += glasses * 0.25;
          } else if (usage == 'Showering') {
            double timeValue = 0;
            switch (docData['time_option']) {
              case 'Quick':
                timeValue = 3;
                break;
              case 'Medium':
                timeValue = 5;
                break;
              case 'Long':
                timeValue = 8;
                break;
              default:
                timeValue = 0;
            }
            if (docData['leakage'] == 'Yes') {
              timeValue += 2;
            }
            showeringTotal += timeValue;
          } else if (usage == 'Cooking') {
            double value = 1;
            if (docData['leakage'] == 'Yes') {
              value += 1;
            }
            cookingTotal += value;
          } else if (usage == 'Toilet') {
            double value = 10;
            if (docData['leakage'] == 'Yes') {
              value += 2;
            }
            toiletTotal += value;
          }
        }

        setState(() {
          activityData = {
            'drinking': drinkingTotal,
            'showering': showeringTotal,
            'cooking': cookingTotal,
            'Toilet': toiletTotal,
          };
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('track_usage')
            .add({
              'date': formattedDate,
              'usage': 'Drinking',
              'quantity': '0',
              'time_option': null,
              'leakage': null,
              'unit_cost': '',
            });

        setState(() {
          activityData = {
            'drinking': 0.0,
            'showering': 0.0,
            'cooking': 0.0,
            'Toilet': 0.0,
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAC4),
      bottomNavigationBar: _CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingPage())),
                  ),
                  const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE9DCC7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _loadDataForDate(selectedDay);
                  },
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    ActivityCard(label: "Drinking", progress: activityData['drinking'], goal: 2.0, emoji: "🧑‍⚕️"),
                    ActivityCard(label: "Showering", progress: activityData['showering'], goal: 20.0, emoji: "🚿"),
                    ActivityCard(label: "Cooking", progress: activityData['cooking'], goal: 6.0, emoji: "🧑‍🍳"),
                    ActivityCard(label: "Toilet", progress: activityData['Toilet'], goal: 30.0, emoji: "🚽"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String label;
  final dynamic progress;
  final dynamic goal;
  final String emoji;

  const ActivityCard({
    super.key,
    required this.label,
    required this.progress,
    required this.goal,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    double percent = (progress is num && goal is num && goal > 0) ? (progress / goal) : 0.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          const SizedBox(height: 6),
          Text("$progress/$goal litre"),
        ],
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
Widget build(BuildContext context) {
  List<IconData> icons = [
    Icons.pie_chart,
    Icons.calendar_today,
    Icons.home,
    Icons.emoji_events_outlined,
    Icons.water_drop_outlined,
  ];

  return SafeArea( // 👈 ห่อด้วย SafeArea
    top: false, // ไม่ต้องห่วงด้านบน
    child: Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFE9DCC7),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.asMap().entries.map((entry) {
          int idx = entry.key;
          IconData icon = entry.value;
          return IconButton(
            icon: Icon(icon, size: 28, color: selectedIndex == idx ? Colors.black : Colors.grey),
            onPressed: () => onItemTapped(idx),
          );
        }).toList(),
      ),
    ),
  );
}

}
