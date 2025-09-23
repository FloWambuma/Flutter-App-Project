import 'package:flutter/material.dart';
import 'package:shop_smart/widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitlesTextWidget(label: "Search Products"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                filled: true,
                fillColor: Colors.grey[300], // 🔹 Change to any visible color
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // TODO: handle search logic here
              },
            ),
            const SizedBox(height: 20),
            // TODO: Add search results here
            Expanded(
              child: Center(
                child: Text(
                  _searchController.text.isEmpty
                      ? "Start typing to search..."
                      : "Searching for: ${_searchController.text}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
