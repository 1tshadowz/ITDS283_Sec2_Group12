import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // เพิ่ม Firestore import
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';
import 'setting.dart';

class TrackWaterPage extends StatefulWidget {
  const TrackWaterPage({super.key});

  @override
  State<TrackWaterPage> createState() => _TrackWaterPageState();
}

class _TrackWaterPageState extends State<TrackWaterPage> {
  final List<String> _timeOptions = ['Quick', 'Medium', 'Long'];
  String? usage;
  String? timeOption;
  String? date;
  String? leakage;

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController perUnitController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  int selectedIndex = 0;

  // ฟังก์ชันสร้าง Dropdown ที่รับรายการ item เป็นพารามิเตอร์
  Widget buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
        value: value,
        icon: const Icon(Icons.arrow_drop_down),
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ฟังก์ชันสร้าง TextField สำหรับกรอกตัวเลข
  Widget buildNumberField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
      ),
    );
  }

  // ฟังก์ชันจัดการการคลิกบนเมนู bottom navigation
  void _onItemTapped(int index) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      // อยู่ที่ Track page อยู่แล้ว
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

  // ฟังก์ชันสำหรับเลือกวันที่
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        date = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // ฟังก์ชันเพื่อบันทึกข้อมูลลง Firestore
  Future<void> _submitData() async {
    // ✅ ตรวจสอบก่อนว่ากรอกข้อมูลครบหรือไม่
    if (usage == null ||
        date == null ||
        (usage == 'Drinking' && quantityController.text.isEmpty) ||
        (usage == 'Showering' && (timeOption == null || leakage == null)) ||
        ((usage == 'Cooking' || usage == 'Toilet') && leakage == null)) {
      _showAlert('Please complete all required fields.', false);
      return;
    }

    // ✅ หากข้อมูลครบแล้วค่อยส่งเข้า Firestore
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentReference ref =
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('track_usage')
                .doc(); // สร้างเอกสารอัตโนมัติ

        await ref.set({
          'usage': usage,
          'time_option': timeOption,
          'quantity': quantityController.text,
          'unit_cost': perUnitController.text,
          'leakage': leakage,
          'date': date,
        });

        _showAlert('Data saved successfully!', true);
      } catch (e) {
        _showAlert('Failed to save data: $e', false);
      }
    }
  }

  // ฟังก์ชันแสดง alert
  void _showAlert(String message, bool success) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Notification'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (success) {
                    // After success, navigate to DashboardPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ActivityPage()),
                    );
                  }
                },
                child: const Text('OK'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                            MaterialPageRoute(
                              builder: (_) => const SettingPage(),
                            ),
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
                const Text(
                  "Track your water usage",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                buildDropdown(
                  "What you use water for?",
                  usage,
                  ['Drinking', 'Showering', 'Cooking', 'Toilet'],
                  (val) {
                    setState(() {
                      usage = val;
                      // Clear related fields when a new usage type is selected
                      if (usage == 'Drinking') {
                        timeOption = null;
                        leakage = null;
                      } else if (usage == 'Showering') {
                        timeOption = 'Medium';
                        leakage = 'No';
                      } else if (usage == 'Cooking' || usage == 'Toilet') {
                        timeOption = null;
                        leakage = 'No';
                      }
                    });
                  },
                ),
                if (usage == 'Showering') ...[
                  buildDropdown(
                    "Select your shower time",
                    timeOption,
                    _timeOptions,
                    (val) => setState(() => timeOption = val),
                  ),
                ] else if (usage == 'Drinking') ...[
                  buildNumberField(
                    "How many glasses of water?",
                    quantityController,
                  ),
                ],
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            date ?? 'Select Date',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                if (usage != null && usage != 'Drinking') ...[
                  buildDropdown(
                    "Did you notice any leaking taps or pipes?",
                    leakage,
                    ['Yes', 'No'],
                    (val) => setState(() => leakage = val),
                  ),
                ],
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:
                      _submitData, // Save data to Firestore when the user confirms
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
