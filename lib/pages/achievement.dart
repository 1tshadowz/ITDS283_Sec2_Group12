import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'products.dart';
import 'setting.dart';

class AchievementPage extends StatefulWidget {
  final String title;

  const AchievementPage({super.key, required this.title});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  int selectedIndex = 3;

  List<Map<String, dynamic>> achievements = [];

  @override
  void initState() {
    super.initState();
    fetchAchievements();
  }

  Future<void> fetchAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final today = "${now.day}/${now.month}/${now.year}";

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('track_usage')
            .get();

    bool drank = false;
    bool showered = false;
    bool cooked = false;
    bool toilet = false;
    int weeklyTotal = 0;
    int monthlyTotal = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data();
      String? dateStr = data['date'];
      if (dateStr == null) continue;

      bool isToday = dateStr == today;

      int amount = 0;
      if (data['usage'] == 'Drinking') {
        if (isToday) drank = true;
        amount += int.tryParse(data['quantity'] ?? '0') ?? 0;
      } else if (data['usage'] == 'Showering') {
        if (isToday) showered = true;
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
        if (isToday) cooked = true;
        amount += 1;
        if (data['leakage'] == 'Yes') amount += 1;
      } else if (data['usage'] == 'Toilet') {
        if (isToday) toilet = true;
        amount += 10;
        if (data['leakage'] == 'Yes') amount += 2;
      }

      try {
        DateTime date = DateFormat('d/M/yyyy').parse(dateStr);
        if (date.isAfter(now.subtract(const Duration(days: 7)))) {
          weeklyTotal += amount;
        }
        if (date.month == now.month && date.year == now.year) {
          monthlyTotal += amount;
        }
      } catch (_) {}
    }

    int completedToday = 0;
    if (drank) completedToday++;
    if (showered) completedToday++;
    if (cooked) completedToday++;
    if (toilet) completedToday++;

    const int weeklyGoal = 100;
    const int monthlyGoal = 400;

    setState(() {
      achievements = [
        {
          'title': 'Today, You added your Drinking',
          'progress': drank ? '1/1' : '0/1',
          'color': const Color(0xFFB2D9B2),
          'completed': drank,
        },
        {
          'title': 'Today, You added your Showering',
          'progress': showered ? '1/1' : '0/1',
          'color': const Color(0xFFB2D9B2),
          'completed': showered,
        },
        {
          'title': 'Today, You added your Cooking',
          'progress': cooked ? '1/1' : '0/1',
          'color': const Color(0xFFB2D9B2),
          'completed': cooked,
        },
        {
          'title': 'Today, You added your Toilet',
          'progress': toilet ? '1/1' : '0/1',
          'color': const Color(0xFFB2D9B2),
          'completed': toilet,
        },
        {
          'title': 'Participated in Water Saving Event!',
          'progress': '0/1',
          'color': const Color(0xFFFFD54F),
          'completed': false,
        },
        {
          'title': 'Reached Today Personal Goal!',
          'progress': '${completedToday.clamp(0, 4)}/4',
          'color': const Color(0xFFD0E8F2),
          'completed': completedToday >= 4,
        },
        {
          'title': 'Weekly Goal: Use less than $weeklyGoal litres',
          'progress': '$weeklyTotal/$weeklyGoal',
          'color': const Color(0xFF219EBC),
          'completed': weeklyTotal < weeklyGoal,
        },
        {
          'title': 'Monthly Goal: Use less than $monthlyGoal litres',
          'progress': '$monthlyTotal/$monthlyGoal',
          'color': const Color(0xFF023047),
          'completed': monthlyTotal < monthlyGoal,
        },
      ];
    });
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
      AchievementPage(title: "Achievements"),
      const ProductPage(),
    ];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => pages[index]),
    );
  }

  double getProgressValue(String progress) {
    final parts = progress.split('/');
    final current = double.tryParse(parts[0]) ?? 0;
    final total = double.tryParse(parts[1]) ?? 1;
    return current / total;
  }

  Widget buildAchievementCard(Map<String, dynamic> achievement) {
    String progress = achievement['progress'];
    double progressValue = getProgressValue(progress);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 79, 150, 168),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement['progress'],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: (achievement['color'] as Color).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement['completed'] ? Icons.check : Icons.star_outline,
                  color: achievement['color'] as Color,
                  size: 60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    achievement['color'],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAC4),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingPage()),
                      );
                    },
                  ),
                  const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: achievements.length,
                itemBuilder:
                    (context, index) =>
                        buildAchievementCard(achievements[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
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

    return SafeArea(
      // 👈 ห่อด้วย SafeArea
      top: false, // ไม่ต้องห่วงด้านบน
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFFE9DCC7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              icons.asMap().entries.map((entry) {
                int idx = entry.key;
                IconData icon = entry.value;
                return IconButton(
                  icon: Icon(
                    icon,
                    size: 28,
                    color: selectedIndex == idx ? Colors.black : Colors.grey,
                  ),
                  onPressed: () => onItemTapped(idx),
                );
              }).toList(),
        ),
      ),
    );
  }
}
