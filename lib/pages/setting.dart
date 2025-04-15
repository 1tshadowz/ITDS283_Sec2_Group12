import 'package:flutter/material.dart';
import 'track.dart';
import 'activity.dart';
import 'dashboard.dart';
import 'products.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int selectedIndex = 5; // Custom index for settings if needed

  // Text controllers for the fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
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
      backgroundColor: const Color(0xFF8ECAC4), // สีพื้นหลัง
      appBar: AppBar(
        backgroundColor: const Color(0xFF8ECAC4),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.settings, color: Colors.white, size: 28),
            Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // กรอบโปรไฟล์และช่องกรอกข้อมูลที่มีขอบมน
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 253, 245),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ช่องรูปโปรไฟล์และปุ่มอัพเดท
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // การอัพเดทโปรไฟล์
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("อัพเดทโปรไฟล์")),
                          );
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: const Color.fromARGB(255, 255, 240, 205), // ขอบเหลือง
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: const AssetImage('assets/images/profile.jpg'), // รูปโปรไฟล์
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Username", // ชื่อผู้ใช้
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ช่องกรอกข้อมูล Username
                    _buildTextField(
                      label: "Username",
                      hintText: "Change Username",
                      controller: usernameController,
                      icon: Icons.edit,
                      labelColor: Colors.teal, // เปลี่ยนสีข้อความ
                    ),
                    const SizedBox(height: 10),

                    // ช่องกรอกข้อมูลรหัสผ่านเก่า
                    _buildTextField(
                      label: "Old Password",
                      hintText: "Enter Old Password",
                      controller: oldPasswordController,
                      icon: Icons.edit,
                      obscureText: true,
                      labelColor: Colors.teal, // เปลี่ยนสีข้อความ
                    ),
                    const SizedBox(height: 10),

                    // ช่องกรอกข้อมูลรหัสผ่านใหม่
                    _buildTextField(
                      label: "Change Password",
                      hintText: "Enter New Password",
                      controller: newPasswordController,
                      icon: Icons.edit,
                      obscureText: true,
                      labelColor: Colors.teal, // เปลี่ยนสีข้อความ
                    ),
                    const SizedBox(height: 10),

                    // ช่องกรอกข้อมูลหมายเลขโทรศัพท์
                    _buildTextField(
                      label: "Telephone Number",
                      hintText: "Change Telephone Number",
                      controller: phoneController,
                      icon: Icons.edit,
                      labelColor: Colors.teal, // เปลี่ยนสีข้อความ
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ปุ่มยืนยันย้ายออกจากกล่องโปรไฟล์และตั้งให้ตรงกลาง
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // การยืนยันการเปลี่ยนแปลง
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile Updated")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 190, 252, 191), // เปลี่ยนสีของกล่อง
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(350, 50), // ขยายขนาดให้กว้างขึ้น
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 18, color: Colors.black), // เปลี่ยนสีข้อความ
                  ),
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

  // ฟังก์ชันสร้างกล่องไอคอนที่มีขอบมน
  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    required Color labelColor, // รับค่า color ของ label
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ใส่คำอธิบายชื่อช่อง พร้อมสี
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: labelColor),
          ),
          const SizedBox(height: 10),
          // ช่องกรอกข้อมูล
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black), // ขอบสีดำ
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(icon, color: Colors.grey),
                  onPressed: () {
                    // Handle icon button press
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Edit $label")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom Navigation Bar widget
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
