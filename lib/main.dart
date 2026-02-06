import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_page.dart';
import 'screens/view_all_requests.dart';
import 'screens/request_details.dart';
import 'screens/update_request.dart';
import 'screens/resident_dashboard.dart';
import 'screens/management_dashboard.dart';
import 'screens/create_announcement.dart';
import 'screens/view_announcements.dart';
import 'screens/my_requests.dart';
import 'screens/service_request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        switch (settings.name) {
          case "/request_details":
            return MaterialPageRoute(
              builder: (_) => RequestDetails(
                request: args as DocumentSnapshot,
              ),
            );

          case "/update_request":
            return MaterialPageRoute(
              builder: (_) => UpdateRequestScreen(
                requestId: args?.toString() ?? "",
              ),
            );

          case "/resident_dashboard":
            return MaterialPageRoute(
              builder: (_) => ResidentDashboard(
                role: args?.toString() ?? "",
              ),
            );

          case "/management_dashboard":
            return MaterialPageRoute(
              builder: (_) => ManagementDashboard(
                role: args?.toString() ?? "",
              ),
            );
        }
        return null;
      },
      routes: {
        "/login": (_) => LoginScreen(),
        "/register": (_) => RegisterScreen(),
        "/home": (_) => const HomePage(),
        "/service_form": (_) => ServiceRequestForm(),
        "/my_requests": (_) => const MyRequests(),
        "/view_all_requests": (_) => const ViewAllRequests(),
        "/create_announcement": (_) => const CreateAnnouncement(),
        "/view_announcements": (_) => const ViewAnnouncements(),
      },
    );
  }
}
