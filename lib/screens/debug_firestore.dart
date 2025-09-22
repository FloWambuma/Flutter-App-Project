import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDebugScreen extends StatefulWidget {
  const FirestoreDebugScreen({super.key});

  static const routeName = "/firestoreDebug";

  @override
  State<FirestoreDebugScreen> createState() => _FirestoreDebugScreenState();
}

class _FirestoreDebugScreenState extends State<FirestoreDebugScreen> {
  int productsCount = 0;
  String status = "Checking Firestore...";

  @override
  void initState() {
    super.initState();
    checkProductsCollection();
  }

  Future<void> checkProductsCollection() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      setState(() {
        productsCount = snapshot.docs.length;
        status = "Products collection found!";
      });
    } catch (e) {
      setState(() {
        status = "Error: $e";
      });
    }
  }

  Future<void> addTestProduct() async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': 'Test Product',
        'price': 9.99,
        'description': 'This is a test product',
        'image': 'assets/images/placeholder.png',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await checkProductsCollection();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Test product added')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Debug")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(status),
            const SizedBox(height: 20),
            Text("Products count: $productsCount"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTestProduct,
              child: const Text("Add Test Product"),
            ),
          ],
        ),
      ),
    );
  }
}
