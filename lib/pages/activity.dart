import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import 'track.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';
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
    'drinking': 0,
    'showering': 0,
    'cooking': 0,
    'planting': 0,
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
    final String formatted = DateFormat('yyyy-MM-dd').format(date);
    final data = await DatabaseHelper.instance.getDailySummaryByDate(formatted);

    setState(() {
      activityData = data;
    });
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
                    ActivityCard(label: "Drinking", progress: int.tryParse(activityData['drinking'].toString()) ?? 0, goal: 2, emoji: "🧑‍⚕️"),
                    ActivityCard(label: "Showering", progress: int.tryParse(activityData['showering'].toString()) ?? 0, goal: 20, emoji: "🚿"),
                    ActivityCard(label: "Cooking", progress: int.tryParse(activityData['cooking'].toString()) ?? 0, goal: 6, emoji: "🧑‍🍳"),
                    ActivityCard(label: "Using Toilet", progress: int.tryParse(activityData['using toilet'].toString()) ?? 0, goal: 20, emoji: "🚽"),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
