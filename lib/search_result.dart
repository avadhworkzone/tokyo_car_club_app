import 'package:flutter/material.dart';
import 'package:tokyo_car_club/screens/Home/car_detail.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  int selectedFilter = 0;

  final filters = ["Price", "Seats", "Transmission", "Fuel", "Car Type"];

  final sortingOptions = ["Relevance", "Price: Low → High", "Rating"];

  String selectedSorting = "Relevance";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0D14),
        resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0D14),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Search Results",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ FILTERS BAR
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (_, i) {
                final isActive = selectedFilter == i;
                return GestureDetector(
                  onTap: () => setState(() => selectedFilter = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : const Color(0xFF141820),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      filters[i],
                      style: TextStyle(
                        color: isActive ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ⭐ SORT DROPDOWN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: DropdownButtonFormField(
              dropdownColor: const Color(0xFF141820),
              value: selectedSorting,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF141820),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
              ),
              items: sortingOptions.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedSorting = v.toString()),
            ),
          ),

          const SizedBox(height: 20),

          // ⭐ RESULTS LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: 5,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarDetailsPage()),
                  );
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141820),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          "assets/images/car.png",
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // NAME
                      const Text(
                        "BMW 5 Series - Luxury",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // TAGS
                      Row(children: [_tag("Automatic"), _tag("Petrol")]),

                      const SizedBox(height: 10),

                      const Text(
                        "₹4,500/day",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _tag(String text) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white70)),
  );
}
