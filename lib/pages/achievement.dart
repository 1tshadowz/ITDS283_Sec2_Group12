import 'package:flutter/material.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'products.dart';
import 'news.dart';

class AchievementPage extends StatefulWidget {
  final String title;

  const AchievementPage({super.key, required this.title});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  int selectedIndex = 3;

  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'Today, You added your Water Usage!',
      'progress': '1/1', 
      'color': const Color(0xFFB2D9B2),
      'completed': true,
    },
    {
      'title': 'Participated in Water Saving Event!',
      'progress': '0/1', 
      'color': Colors.grey,
      'completed': false,
    },
    {
      'title': 'Reached Personal Water Goal!',
      'progress': '2/5', 
      'color': const Color(0xFFD0E8F2),
      'completed': false,
    },
  ];

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const TrackWaterPage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ActivityPage()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else if (index == 4) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ProductPage()));
    }
  }

  double getProgressValue(String progress) {
    final parts = progress.split('/');  
    final current = int.parse(parts[0]); 
    final total = int.parse(parts[1]);

    return current / total; 
  }

  // Widget สำหรับการ์ด Achievement
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
          // Text อยู่ทางซ้าย, ไอคอนอยู่ทางขวา
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement['title'],
                      style: const TextStyle(
                        fontSize: 28,  
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
              // ไอคอนจะอยู่ทางขวาสุด
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
          // LinearProgressIndicator อยู่ด้านล่าง
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
                children: const [
                  Icon(Icons.settings, color: Colors.white, size: 28),
                  Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  return buildAchievementCard(achievements[index]);
                },
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
        children: icons.asMap().entries.map((entry) {
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
