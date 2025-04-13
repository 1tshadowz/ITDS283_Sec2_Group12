import 'package:flutter/material.dart';
import 'create_account_page.dart';
import 'dashboard.dart';
import '../db/db_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final db = await DatabaseHelper.instance.database;
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (users.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      _showAlert("Incorrect email or password.");
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Failed"),
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
      backgroundColor: const Color(0xFFE7DAC7),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text("Step in and start your\njourney with Us!", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  const Align(alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email',
                      filled: true,
                      fillColor: const Color(0xFFE7DAC7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(alignment: Alignment.centerLeft, child: Text("Password")),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      filled: true,
                      fillColor: const Color(0xFFE7DAC7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8CBAB7)),
                      onPressed: _login,
                      child: const Text("Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Haven’t create an account? ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAccountPage())),
                        child: const Text("Sign Up", style: TextStyle(color: Color(0xFF8CBAB7), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
