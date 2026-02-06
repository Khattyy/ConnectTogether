import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestDetails extends StatelessWidget {
  final DocumentSnapshot request;

  const RequestDetails({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final data = request.data() as Map<String, dynamic>;

    final category = data["category"];
    final description = data["description"];
    final fullName = data["fullName"];
    final status = data["status"];
    final timestamp = data["timestamp"];

    final dateFormatted = DateFormat("dd MMM yyyy • hh:mm a")
        .format(timestamp.toDate());

    Color statusColor = Colors.orangeAccent;
    if (status == "Approved") statusColor = Colors.greenAccent;
    if (status == "Rejected") statusColor = Colors.redAccent;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/onboarding_management2.jpg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(color: Colors.black.withOpacity(0.45)),

          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Request Details",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Submitted by: $fullName",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Current Status:",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // APPROVE BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    updateStatus("Approved", context);
                  },
                  child: const Text("Approve", style: TextStyle(color: Colors.black)),
                ),

                const SizedBox(height: 10),

                // REJECT BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    updateStatus("Rejected", context);
                  },
                  child: const Text("Reject", style: TextStyle(color: Colors.black)),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateStatus(String newStatus, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("service_requests")
        .doc(request.id)
        .update({"status": newStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Request updated to $newStatus")),
    );

    Navigator.pop(context);
  }
}
