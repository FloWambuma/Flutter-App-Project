import 'package:flutter/material.dart';

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
    _searchController =
        TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    // 🔹 Add your search logic here
    print("Searching for: $query");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (_) => _onSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearch,
          ),
        ],
      ),
      body: Center(
        child: Text(
          _searchController.text.isEmpty
              ? "Enter a product name to search"
              : "Results for '${_searchController.text}'",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
