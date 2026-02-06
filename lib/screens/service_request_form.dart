import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceRequestForm extends StatefulWidget {
  const ServiceRequestForm({super.key});

  @override
  State<ServiceRequestForm> createState() => _ServiceRequestFormState();
}

class _ServiceRequestFormState extends State<ServiceRequestForm> {
  final fullName = TextEditingController();
  final description = TextEditingController();

  String selectedCategory = "Plumbing";
  bool loading = false;

  // Submit to Firestore
  Future<void> submitRequest() async {
    if (fullName.text.isEmpty || description.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection("service_requests").add({
        "uid": user?.uid ?? "",
        "fullName": fullName.text.trim(),
        "description": description.text.trim(),
        "category": selectedCategory,
        "status": "Pending",
        "timestamp": DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request submitted successfully!")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            "assets/onboarding_management2.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.45)),

          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 360,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Service Request Form",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    _inputField(fullName, "Full Name"),

                    // Dropdown
                    _dropdownField(),

                    // Description
                    _inputField(description, "Describe the Issue", maxLines: 4),

                    const SizedBox(height: 20),

                    // Button
                    ElevatedButton(
                      onPressed: loading ? null : submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0B74D),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Submit Request",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 45,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  // Beautiful text field
  Widget _inputField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.25),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Beautiful dropdown
  Widget _dropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedCategory,
          dropdownColor: Colors.black,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: const [
            DropdownMenuItem(value: "Plumbing", child: Text("Plumbing")),
            DropdownMenuItem(value: "Electrical", child: Text("Electrical")),
            DropdownMenuItem(value: "Cleaning", child: Text("Cleaning")),
            DropdownMenuItem(value: "Security", child: Text("Security")),
            DropdownMenuItem(value: "Others", child: Text("Others")),
          ],
          onChanged: (value) {
            setState(() {
              selectedCategory = value.toString();
            });
          },
        ),
      ),
    );
  }
}
