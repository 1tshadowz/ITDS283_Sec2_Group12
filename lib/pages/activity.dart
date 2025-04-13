import 'package:flutter/material.dart';
import 'track.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int selectedIndex = 1; // Activity is index 1

  void _onItemTapped(int index) {
    if (index == selectedIndex) {
      // Refresh the page if tapped again
      setState(() {});
      return;
    }

    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrackWaterPage()));
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AchievementPage(title: "Achievements")));
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductPage()));
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
                children: const [
                  Icon(Icons.settings, color: Colors.white, size: 28),
                  Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9DCC7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Feb 2025",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Table(
                      children: [
                        _buildCalendarRow(["S", "M", "T", "W", "T", "F", "Sa"], bold: true),
                        _buildCalendarRow(["", "", "", "", "", "", "1"]),
                        _buildCalendarRow(["2", "3", "4", "5", "6", "7", "8"]),
                        _buildCalendarRow(["9", "10", "11", "12", "13", "14", "15"]),
                        _buildCalendarRow(["16", "17", "18", "19", "20", "21", "22"], highlight: "19"),
                        _buildCalendarRow(["23", "24", "25", "26", "27", "28", ""]),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: const [
                    ActivityCard(label: "Drinking", progress: 5203, goal: 10000, emoji: "🧑‍⚕️"),
                    ActivityCard(label: "Showering", progress: 4636, goal: 10000, emoji: "🚿"),
                    ActivityCard(label: "Cooking", progress: 3000, goal: 10000, emoji: "🧑‍🍳"),
                    ActivityCard(label: "Watering the Plant", progress: 2000, goal: 10000, emoji: "🌱"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildCalendarRow(List<String> days, {bool bold = false, String? highlight}) {
    return TableRow(
      children: days.map((day) {
        bool isHighlight = day == highlight;
        return Padding(
          padding: const EdgeInsets.all(4),
          child: Center(
            child: CircleAvatar(
              backgroundColor: isHighlight ? Colors.teal : Colors.transparent,
              radius: 14,
              child: Text(
                day,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: isHighlight ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String label;
  final int progress;
  final int goal;
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
    double percent = progress / goal;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          const SizedBox(height: 6),
          Text("$progress/$goal"),
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
