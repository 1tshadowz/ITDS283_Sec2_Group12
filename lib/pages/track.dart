import 'package:flutter/material.dart';
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
  // รายการสำหรับ Dropdown ของแต่ละคำถาม
  final List<String> _usageItems = [
    'Select',
    'Drinking',
    'Showering',
    'Cooking',
    'Watering Plant',
  ];
  final List<String> _buildingTypeItems = ['Select', 'House', 'Condo'];
  final List<String> _leakageItems = ['Select', 'Yes', 'No'];
  final List<String> _satisfactionItems = ['Select', '1', '2', '3', '4', '5'];

  String? usage;
  String? buildingType;
  String? leakage;
  String? satisfaction;

  // สำหรับช่องกรอกตัวเลข
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController perUnitController = TextEditingController();

  int selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9ED3D5),
      body: SafeArea(
        child: SingleChildScrollView(
          // SingleChildScrollView ช่วยให้กรณีคีย์บอร์ดเปิดแล้วหน้าเลื่อนได้
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 28),
              onPressed: () {
                // Navigate to Settings Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingPage()), // Navigate to settings
                );
              },
            ),
            const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
          ],
                ),
                const SizedBox(height: 20),
                // What you use water for?
                buildDropdown(
                  "What you use water for?",
                  usage,
                  _usageItems,
                  (val) => setState(() => usage = val),
                ),
                // Which type of your building?
                buildDropdown(
                  "Which type of your building?",
                  buildingType,
                  _buildingTypeItems,
                  (val) => setState(() => buildingType = val),
                ),
                // ถ้า usage ไม่เท่ากับ "Cooking" จะแสดงช่องกรอกตัวเลข
                if (usage != "Cooking") ...[
                  buildNumberField("Used water quantity", quantityController),
                  buildNumberField(
                    "How about water per Units (price per unit)",
                    perUnitController,
                  ),
                ],
                // Did you notice any leaking taps or pipes?
                buildDropdown(
                  "Did you notice any leaking taps or pipes?",
                  leakage,
                  _leakageItems,
                  (val) => setState(() => leakage = val),
                ),
                // How satisfied are you with your current water usage habits?
                buildDropdown(
                  "How satisfied are you with your current water usage habits?",
                  satisfaction,
                  _satisfactionItems,
                  (val) => setState(() => satisfaction = val),
                ),
                const SizedBox(height: 20),
                // Confirm button
                // ElevatedButton เป็นปุ่มที่มีการยกตัวขึ้นเมื่อกด
                ElevatedButton(
                  // Handle submission here
                // สามารถนำข้อมูลจากตัวแปร (usage, buildingType, quantityController.text, perUnitController.text, leakage, satisfaction)
                // ไปประมวลผลหรือต่อการแสดงผลได้ตามต้องการ
                  onPressed: () {
                    // แสดง AlertDialog หลังจากกด Confirm
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Update Success"),
                            content: const Text(
                              "Data updated successfully.\n(Note: No real data submission has been made.)",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // ปิด AlertDialog
                                  Navigator.pop(context);
                                  // นำไปยังหน้า ActivityPage
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ActivityPage(),
                                    ),
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                    );
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
