import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'news.dart';
import 'track.dart';
import 'activity.dart';
import 'achievement.dart';
import 'products.dart';
import 'setting.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  int selectedIndex = 2;
  Map<String, int> weeklyData = {};
  late AnimationController _waveController;
  double averageCost = 0.0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    fetchWeeklyUsage();
    fetchWaterCostData();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });

    final pages = [
      const TrackWaterPage(),
      const ActivityPage(),
      const DashboardPage(),
      const AchievementPage(title: "Achievements"),
      const ProductPage()
    ];

    if (index >= 0 && index <= 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[index]));
    }
  }

  Future<void> fetchWeeklyUsage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 6));
    final firestore = FirebaseFirestore.instance;

    Map<String, int> dailyTotals = {};

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('track_usage')
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      String? dateStr = data['date'];
      if (dateStr == null) continue;

      try {
        DateTime date = DateFormat('d/M/yyyy').parse(dateStr);
        if (date.isBefore(startDate) || date.isAfter(now)) continue;

        String key = DateFormat('EEE').format(date);

        int amount = 0;
        if (data['usage'] == 'Drinking') {
          amount += int.tryParse(data['quantity'] ?? '0') ?? 0;
        } else if (data['usage'] == 'Showering') {
          switch (data['time_option']) {
            case 'Quick':
              amount += 3;
              break;
            case 'Medium':
              amount += 5;
              break;
            case 'Long':
              amount += 8;
              break;
          }
          if (data['leakage'] == 'Yes') amount += 2;
        } else if (data['usage'] == 'Cooking') {
          amount += 1;
          if (data['leakage'] == 'Yes') amount += 1;
        } else if (data['usage'] == 'Toilet') {
          amount += 10;
          if (data['leakage'] == 'Yes') amount += 2;
        }

        dailyTotals[key] = (dailyTotals[key] ?? 0) + amount;
      } catch (e) {
        print("❌ Error parsing date: $dateStr -> $e");
      }
    }

    setState(() {
      weeklyData = dailyTotals;
    });
  }

  Future<void> fetchWaterCostData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('usage')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();

      double lastMonth = double.tryParse(data['last_month'].toString()) ?? 0;
      double last2Month = double.tryParse(data['last_2_month'].toString()) ?? 0;
      double last3Month = double.tryParse(data['last_3_month'].toString()) ?? 0;
      double cost = double.tryParse(data['cost'].toString()) ?? 0;

      averageCost = ((lastMonth + last2Month + last3Month) / 3) * cost;

      print('💧 last_month: $lastMonth');
      print('💧 last_2_month: $last2Month');
      print('💧 last_3_month: $last3Month');
      print('💸 cost per unit: $cost');
      print('📊 average cost: $averageCost');

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    int todayTotal = weeklyData[DateFormat('EEE').format(DateTime.now())] ?? 0;
    double waterPercent = (1 - (todayTotal / 30)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF8ECAC4),
      bottomNavigationBar: _CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
                margin: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.lightBlueAccent,
                      Colors.blue.withOpacity(waterPercent),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("WARNING!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 20),
                    const Text("Save Water, track every drop.", style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                    const SizedBox(height: 10),
                    Text("Your Last Average water bills ${averageCost.toStringAsFixed(2)} BAHT", style: const TextStyle(fontSize: 14, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Weekly Report", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                          final value = weeklyData[day] ?? 0;
                          final barHeight = value * 3.0;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("$value", style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                              Container(
                                width: 14,
                                height: barHeight.clamp(0, 100),
                                decoration: BoxDecoration(
                                  color: Colors.cyan[700],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(day, style: const TextStyle(fontSize: 10)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 400,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsPage())),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://i.imgur.com/1R6n3WB.png',
                      fit: BoxFit.cover,
                      width: 400,
                      height: 180,
                    ),
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

class _CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

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
