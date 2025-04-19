import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore Import
import 'login.dart'; // ใช้สำหรับนำผู้ใช้ไปหน้า LoginPage

class PreInputPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final String phone;

  const PreInputPage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  State<PreInputPage> createState() => _PreInputPageState();
}

class _PreInputPageState extends State<PreInputPage> {
  final TextEditingController lastMonthController = TextEditingController();
  final TextEditingController last2MonthController = TextEditingController();
  final TextEditingController last3MonthController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  String selectedWaterType = 'Tap Water';
  bool isChecked1 = false;
  bool isChecked2 = false;

  Future<void> _submitData() async {
    // รวมข้อมูลทั้งหมดจากหน้า PreInputPage และ CreateAccountPage
    final result = {
      'username': widget.username,
      'email': widget.email,
      'phone': widget.phone,
      'last_month': double.tryParse(lastMonthController.text) ?? 0.0,
      'last_2_month': double.tryParse(last2MonthController.text) ?? 0.0,
      'last_3_month': double.tryParse(last3MonthController.text) ?? 0.0,
      'water_type': selectedWaterType,
      'cost': double.tryParse(costController.text) ?? 0.0,
      'record_bill': isChecked1 ? 1 : 0,
      'think_waste': isChecked2 ? 1 : 0,
    };

    try {
      // Get current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reference to Firebase Firestore
        DocumentReference userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        // Save the additional user data into Firestore
        await userRef
            .collection('usage')
            .add(result); // ใช้ subcollection 'usage' เพื่อเก็บข้อมูล

        // Show success message
        _showAlert('Your information has been saved successfully!', true);
      }
    } catch (e) {
      // Handle any errors during the saving process
      _showAlert('An error occurred while saving data: $e', false);
    }
  }

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
                    // After success, navigate to LoginPage
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false, // Prevent user from going back
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
      backgroundColor: const Color(0xFFE9DCC7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Let Us Know Your Usage!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              buildTextField('Last Month', lastMonthController),
              buildTextField('Last 2 Month', last2MonthController),
              buildTextField('Last 3 Month', last3MonthController),
              const SizedBox(height: 10),
              const Text('What is the most type of water You use'),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedWaterType,
                items:
                    ['Tap Water', 'Filtered Water', 'Bottled Water']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => selectedWaterType = value!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              buildTextField('Cost of water/Unit', costController),
              const SizedBox(height: 10),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Have you ever recorded your Bill?"),
                value: isChecked1,
                onChanged: (value) => setState(() => isChecked1 = value!),
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Do you think you waste water?"),
                value: isChecked2,
                onChanged: (value) => setState(() => isChecked2 = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CBAB7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed:
                    _submitData, // เมื่อกดปุ่ม จะส่งข้อมูลไปที่ Firestore
                child: const Text(
                  'Submit Information',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
