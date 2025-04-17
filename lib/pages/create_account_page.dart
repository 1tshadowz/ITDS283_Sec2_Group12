import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'preinput_page.dart';

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

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();  // Ensure Firebase is initialized
  }

  Future<void> _goToPreInput() async {
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

    try {
      // Create a new user using Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Send data to PreInputPage
        final result = await Navigator.push(
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

        // When PreInputPage returns, handle the result
        if (result != null) {
          // Use the returned data from PreInputPage (e.g., save to Firebase)
          DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/${userCredential.user!.uid}');
          dbRef.set({
            'username': result['username'],
            'email': result['email'],
            'phone': result['phone'],
            'last_month': result['last_month'],
            'last_2_month': result['last_2_month'],
            'last_3_month': result['last_3_month'],
            'water_type': result['water_type'],
            'cost': result['cost'],
            'record_bill': result['record_bill'],
            'think_waste': result['think_waste'],
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showAlert('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showAlert('The email is already in use.');
      }
    } catch (e) {
      _showAlert('An error occurred. Please try again later.');
    }
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
