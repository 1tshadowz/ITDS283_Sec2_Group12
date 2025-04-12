import 'package:flutter/material.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';

class TrackWaterPage extends StatefulWidget {
  const TrackWaterPage({super.key});

  @override
  State<TrackWaterPage> createState() => _TrackWaterPageState();
}

class _TrackWaterPageState extends State<TrackWaterPage> {
  final List<String> _dropdownItems = [
    'Select',
    'Option 1',
    'Option 2',
    'Option 3'
  ];

  String? usage;
  String? buildingType;
  String? quantity;
  String? perUnit;
  String? leakage;
  String? satisfaction;

  int selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      // Already on Track page
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ActivityPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AchievementPage(title: "Achievements")),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductPage()),
      );
    }
  }

  Widget buildDropdown(String label, String? value, Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        value: value,
        icon: const Icon(Icons.arrow_drop_down),
        items: _dropdownItems
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9ED3D5),
      appBar: AppBar(
        title: const Text("Track Water"),
        backgroundColor: const Color(0xFF9ED3D5),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.settings, size: 30, color: Colors.white), // ← white
                  Icon(Icons.person, size: 30, color: Colors.white),   // ← white
                ],
              ),
              const SizedBox(height: 20),
              buildDropdown("What you use water for?", usage, (val) => setState(() => usage = val)),
              buildDropdown("Which type of your building?", buildingType, (val) => setState(() => buildingType = val)),
              buildDropdown("Used water quantity", quantity, (val) => setState(() => quantity = val)),
              buildDropdown("How about water per Units", perUnit, (val) => setState(() => perUnit = val)),
              buildDropdown("Did you notice any leaking taps or pipes?", leakage, (val) => setState(() => leakage = val)),
              buildDropdown("How satisfied are you with your current water usage habits?", satisfaction, (val) => setState(() => satisfaction = val)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA5E6A0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
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
