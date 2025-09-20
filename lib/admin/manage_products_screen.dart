import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_smart/widgets/product_item.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = "/ManageProductsScreen";

  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }
          final products = snapshot.data!.docs;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, i) => ProductItem(
              productId: products[i].id,
              title: products[i].data()['title'] ?? 'No Title',
              imageUrl: products[i].data()['imageUrl'] ?? '',
            ),
          );
        },
      ),
    );
  }
}
