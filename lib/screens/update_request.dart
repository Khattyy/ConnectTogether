import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateRequestScreen extends StatefulWidget {
  final String requestId;

  const UpdateRequestScreen({super.key, required this.requestId});

  @override
  State<UpdateRequestScreen> createState() => _UpdateRequestScreenState();
}

class _UpdateRequestScreenState extends State<UpdateRequestScreen> {
  String selectedStatus = "Pending";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/onboarding_management2.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.45)),

          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("service_requests")
                .doc(widget.requestId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error loading request",
                      style: TextStyle(color: Colors.white)),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }

              final data = snapshot.data!;
              final category = data["category"];
              final description = data["description"];
              final fullName = data["fullName"];
              final currentStatus = data["status"];

              selectedStatus = currentStatus;

              return Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "Update Request",
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Category: $category",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          const SizedBox(height: 10),
                          Text("Description: $description",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70)),
                          const SizedBox(height: 10),
                          Text("Submitted by: $fullName",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70)),

                          const SizedBox(height: 20),

                          const Text("Update Status",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              dropdownColor: Colors.black87,
                              iconEnabledColor: Colors.white,
                              underline: Container(),
                              style: const TextStyle(color: Colors.white),
                              items: const [
                                DropdownMenuItem(
                                    value: "Pending",
                                    child: Text("Pending",
                                        style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(
                                    value: "Approved",
                                    child: Text("Approved",
                                        style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(
                                    value: "Rejected",
                                    child: Text("Rejected",
                                        style: TextStyle(color: Colors.white))),
                                DropdownMenuItem(
                                    value: "Completed",
                                    child: Text("Completed",
                                        style: TextStyle(color: Colors.white))),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("service_requests")
                                  .doc(widget.requestId)
                                  .update({"status": selectedStatus});

                              Navigator.pop(context);
                            },
                            child: const Text("Save Update",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),

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
}
