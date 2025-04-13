import 'package:flutter/material.dart';
import 'preinput_page.dart';
import '../db/db_helper.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _goToPreInput() async {
    final db = await DatabaseHelper.instance.database;

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirm = _confirmPasswordController.text.trim();
    String phone = _phoneController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty || phone.isEmpty) {
      _showAlert('Please fill in all fields');
      return;
    }

    if (password != confirm) {
      _showAlert('Passwords do not match');
      return;
    }

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty) {
      _showAlert('Email already exists!');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreInputPage(
          username: username,
          email: email,
          password: password,
          phone: phone,
        ),
      ),
    );
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
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
              const Text('Create an Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              _buildTextField('Username', controller: _usernameController),
              _buildTextField('Enter Your Email', controller: _emailController),
              _buildTextField('Enter Your Password', controller: _passwordController, obscureText: true),
              _buildTextField('Confirm Password', controller: _confirmPasswordController, obscureText: true),
              _buildTextField('Telephone Number', controller: _phoneController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8CBAB7), padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _goToPreInput,
                child: const Text('NEXT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text.rich(
                    TextSpan(text: 'Already have an account? ', children: [
                      TextSpan(text: 'Login', style: TextStyle(color: Color(0xFF8CBAB7), fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
