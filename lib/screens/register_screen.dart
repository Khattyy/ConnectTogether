import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  String selectedRole = "Resident";
  bool loading = false;

  Future<void> registerUser() async {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      setState(() => loading = true);

      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());

      await FirebaseFirestore.instance.collection("users").doc(user.user!.uid).set({
        "fullName": fullName.text,
        "email": email.text,
        "role": selectedRole,
      });

      Navigator.pushReplacementNamed(context, "/login");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/onboarding_management2.jpg",
              height: double.infinity, width: double.infinity, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 28)),
                  const SizedBox(height: 20),

                  field(fullName, "Full Name", false),
                  field(email, "Email", false),
                  field(password, "Password", true),
                  field(confirmPassword, "Confirm Password", true),

                  DropdownButtonFormField(
                    dropdownColor: Colors.black87,
                    value: selectedRole,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.25),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Resident", child: Text("Resident")),
                      DropdownMenuItem(value: "Management", child: Text("Management")),
                    ],
                    onChanged: (v) => setState(() => selectedRole = v!),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: loading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0B74D),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text("Sign Up"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget field(TextEditingController c, String hint, bool pass) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: pass,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.25),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
