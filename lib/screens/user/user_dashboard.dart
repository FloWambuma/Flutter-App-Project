import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_smart/screens/auth/login_screen.dart';
import 'package:shop_smart/widgets/title_text.dart';

class UserDashboardScreen extends StatelessWidget {
  static const routeName = '/UserDashboardScreen';
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "User Dashboard"),
        actions: [
          // Login / Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              icon: Icon(user == null ? Icons.login : Icons.logout,
                  color: Colors.white),
              label: Text(user == null ? "Login" : "Logout",
                  style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (user == null) {
                  // Navigate to LoginScreen
                  Navigator.pushNamed(context, LoginScreen.routName);
                } else {
                  // Logout the user
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Signed out successfully ✅"),
                      ),
                    );
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routName);
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: user == null
            ? const Text(
                "Welcome Guest 👋\nPlease login to access features",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              )
            : Text(
                "Welcome ${user.email ?? "User"} 👋",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}
