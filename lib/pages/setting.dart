import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // เพิ่ม Firestore import
import 'activity.dart';
import 'dashboard.dart';
import 'achievement.dart';
import 'products.dart';
import 'track.dart';
import 'login.dart'; // เพิ่ม LoginPage เพื่อใช้การนำทางไปยังหน้าล็อกอิน

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int selectedIndex = 5;

  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  User? user;
  String username = '';  // เพิ่มตัวแปร username เพื่อเก็บข้อมูลจาก Firestore

  @override
  void initState() {
    super.initState();

    // ตรวจสอบผู้ใช้ที่ล็อกอิน
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // โหลดข้อมูลจาก Firestore ไปยัง TextField
      FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((
        DocumentSnapshot snapshot,
      ) {
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          usernameController.text =
              data['username'] ??
              ''; // ใช้ข้อมูล username ที่ดึงมาจาก Firestore
          phoneController.text = data['phone'] ?? '';
        }
      });
    }
  }

  Future<void> _updateProfile() async {
    // ตรวจสอบว่า ผู้ใช้ได้เข้าสู่ระบบหรือไม่
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // ขั้นตอนการ re-authenticate ก่อนทำการอัพเดตรหัสผ่าน
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text.trim(), // รหัสผ่านเก่า
        );

        // Re-authenticate user with their old password
        await user.reauthenticateWithCredential(credential);

        // อัพเดตข้อมูลใน Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'username': usernameController.text.trim(),
              'phone': phoneController.text.trim(),
            });

        // ถ้าผู้ใช้กรอกรหัสผ่านใหม่ ให้ทำการเปลี่ยนรหัสผ่าน
        if (newPasswordController.text.trim().isNotEmpty) {
          await user.updatePassword(newPasswordController.text.trim());
          FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'password': newPasswordController.text.trim(),
          });
          // อัพเดตรหัสผ่านใหม่
        }

        // นำทางไปที่ Dashboard หลังจากอัพเดตสำเร็จ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardPage(),
          ), // นำทางไปที่ Dashboard
        );

        // แจ้งเตือนผู้ใช้ว่าอัพเดตสำเร็จ
        _showAlert('Profile updated successfully!');
      } catch (e) {
        // ถ้ามีข้อผิดพลาดในการอัพเดต
        _showAlert('Failed to update profile: $e');
      }
    } else {
      _showAlert('No user is currently signed in.');
    }
  }

  // ฟังก์ชันแสดงการแจ้งเตือน
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Notification'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(context).pop(), // Close the alert dialog
                child: const Text('OK'),
              ),
            ],
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

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Logout from FirebaseAuth
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ), // Redirect to Login Page
      );
    } catch (e) {
      _showAlert('Failed to log out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAC4),
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
                    Center(
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            240,
                            205,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              'https://i.imgur.com/uWqNEhd.jpeg',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Profile", // แสดงชื่อผู้ใช้ที่ดึงมาจาก Firestore
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: "Username",
                      hintText: "Change Username",
                      controller: usernameController,
                      icon: Icons.edit,
                      labelColor: Colors.teal,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: "Old Password",
                      hintText: "Enter Old Password",
                      controller: oldPasswordController,
                      icon: Icons.edit,
                      obscureText: true,
                      labelColor: Colors.teal,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: "Change Password",
                      hintText: "Enter New Password",
                      controller: newPasswordController,
                      icon: Icons.edit,
                      obscureText: true,
                      labelColor: Colors.teal,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: "Confirm Password",
                      hintText: "Confirm New Password",
                      controller: confirmPasswordController,
                      icon: Icons.edit,
                      obscureText: true,
                      labelColor: Colors.teal,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: "Telephone Number",
                      hintText: "Change Telephone Number",
                      controller: phoneController,
                      icon: Icons.edit,
                      labelColor: Colors.teal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 190, 252, 191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(350, 50),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 252, 194, 190),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(350, 50),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, color: Colors.black),
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    required Color labelColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                Icon(icon, color: Colors.grey),
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
