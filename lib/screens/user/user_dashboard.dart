import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_smart/screens/auth/login_screen.dart';
import 'package:shop_smart/screens/search_screen.dart';
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
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signed out successfully ✅")),
                  );
                  Navigator.pushReplacementNamed(
                    context,
                    LoginScreen.routeName,
                  );
                }
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Search products...",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
