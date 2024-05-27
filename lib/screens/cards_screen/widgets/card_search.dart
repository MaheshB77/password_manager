import 'package:flutter/material.dart';

class CardSearch extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) search;
  
  const CardSearch({
    super.key,
    required this.searchController,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {}, //_showFilters
              icon: const Icon(Icons.filter_alt_outlined),
            ),
            border: const OutlineInputBorder(gapPadding: 5),
            contentPadding: const EdgeInsets.all(8),
          ),
          onChanged: (value) => search(value),
        ),
      ),
    );
  }
}
