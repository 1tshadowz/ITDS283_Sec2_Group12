import 'package:flutter/material.dart';

class PreInputPage extends StatefulWidget {
  const PreInputPage({super.key});

  @override
  State<PreInputPage> createState() => _PreInputPageState();
}

class _PreInputPageState extends State<PreInputPage> {
  bool isChecked1 = false;
  bool isChecked2 = false;

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
              buildTextField('Last Month'),
              buildTextField('Last 2 Month'),
              buildTextField('Last 3 Month'),
              const SizedBox(height: 10),
              const Text('What is the most type of water You use'),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                items: ['Tap Water', 'Filtered Water', 'Bottled Water']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              buildTextField('Cost of water/Unit'),
              const SizedBox(height: 10),

              // Checkbox 1
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Have you ever record your Bill"),
                value: isChecked1,
                onChanged: (value) {
                  setState(() {
                    isChecked1 = value!;
                  });
                },
              ),

              // Checkbox 2
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Press me, If you think you waste water!"),
                value: isChecked2,
                onChanged: (value) {
                  setState(() {
                    isChecked2 = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CBAB7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Add next page navigation or logic here
                },
                child: const Text(
                  'Create an Account',
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

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}