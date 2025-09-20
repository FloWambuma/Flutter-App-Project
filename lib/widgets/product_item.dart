import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  const ProductItem({
    super.key,
    required this.productId,
    required this.title,
    required this.imageUrl,
  });

  Future<void> _deleteProduct(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product deleted successfully ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete product: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        leading: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              )
            : const Icon(Icons.image, size: 50),
        title: Text(title.isNotEmpty ? title : 'No Title'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteProduct(context),
        ),
      ),
    );
  }
}
