import 'package:flutter/material.dart';
import 'login.dart';
import '../db/db_helper.dart';

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
      'last_month': lastMonthController.text,
      'last_2_month': last2MonthController.text,
      'last_3_month': last3MonthController.text,
      'water_type': selectedWaterType,
      'cost': costController.text,
      'record_bill': isChecked1 ? 1 : 0,
      'think_waste': isChecked2 ? 1 : 0,
    };

    // ส่งข้อมูลกลับไปยัง CreateAccountPage
    Navigator.pop(context, result);  // ส่งข้อมูลกลับไป
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
                items: ['Tap Water', 'Filtered Water', 'Bottled Water']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => selectedWaterType = value!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              buildTextField('Cost of water/Unit', costController),
              const SizedBox(height: 10),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Have you ever record your Bill"),
                value: isChecked1,
                onChanged: (value) => setState(() => isChecked1 = value!),
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Press me, If you think you waste water!"),
                value: isChecked2,
                onChanged: (value) => setState(() => isChecked2 = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CBAB7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitData,  // เมื่อกดปุ่ม จะส่งข้อมูลกลับไปที่ CreateAccountPage
                child: const Text(
                  'Create an Account',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
