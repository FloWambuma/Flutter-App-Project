import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_smart/widgets/title_text.dart';

class UserManagementScreen extends StatelessWidget {
  static const routeName = '/UserManagementScreen';
  const UserManagementScreen({super.key});

  Future<void> _deleteUser(String uid, BuildContext context) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User deleted successfully ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "User Management"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("No Users Found"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  title: Text(user['email'] ?? "No Email"),
                  subtitle: Text("UID: ${user.id}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user.id, context),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
