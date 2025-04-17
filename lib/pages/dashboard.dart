import 'package:flutter/material.dart';
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

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 2; // Home is index 2

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrackWaterPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ActivityPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AchievementPage(title: "Achievements"),
        ),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductPage()),
      );
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // Navigate to Settings Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingPage(),
                          ), // Navigate to settings
                        );
                      },
                    ),
                    Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 60,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "WARNING!",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Save Water, track every drop.",
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
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
                      const Text(
                        "Weekly Report",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 70),
                      SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(10, (index) {
                            return Container(
                              width: 10,
                              height: (index % 5 + 2) * 10,
                              decoration: BoxDecoration(
                                color: Colors.cyan[700],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  height: 180, // กำหนดความสูงที่แน่นอน
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      // เมื่อคลิกที่ภาพนี้ ให้ไปที่หน้า NewsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewsPage(),
                        ), // Navigate to NewsPage
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16), // ทำให้ขอบมน
                      child: Image.network(
                        'https://sdmntprwestus2.oaiusercontent.com/files/00000000-8474-61f8-978d-98f5cabcea0c/raw?se=2025-04-17T19%3A41%3A12Z&sp=r&sv=2024-08-04&sr=b&scid=a66d74ea-f80e-578c-8546-f1f7be1a8654&skoid=b53ae837-f585-4db7-b46f-2d0322fce5a9&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-04-16T21%3A28%3A36Z&ske=2025-04-17T21%3A28%3A36Z&sks=b&skv=2024-08-04&sig=KrhxOi5jzFJ7WPSqIjmzowUi0mqRkQwXvOF%2BvxNehno%3D',
                        fit: BoxFit.cover, // ใช้ BoxFit.cover ให้ภาพเต็มพื้นที่
                        width: 400,
                        height: 180, // ปรับให้เหมาะสม
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

    return Container(
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
    );
  }
}
