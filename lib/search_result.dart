import 'package:flutter/material.dart';
import 'package:tokyo_car_club/screens/Home/car_detail.dart';

import 'core/constants/app_colors.dart';

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
        backgroundColor: AppColors.background(context),
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: AppColors.background(context),
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Builder(
                builder: (context) => CircleAvatar(
                  backgroundColor: AppColors.surface(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            "Search Results",
            style: TextStyle(color: AppColors.textPrimary(context)),
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
                        color: isActive
                            ? AppColors.accent(context)
                            : AppColors.cardBackground(context),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Center(
                        child: Text(
                          filters[i],
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppColors.textPrimary(context),
                            fontWeight: FontWeight.w600,
                          ),
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
                dropdownColor: AppColors.cardBackground(context),
                value: selectedSorting,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.cardBackground(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
                items: sortingOptions.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(
                      s,
                      style: TextStyle(color: AppColors.textPrimary(context)),
                    ),
                  );
                }).toList(),
                onChanged: (v) =>
                    setState(() => selectedSorting = v.toString()),
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
                      color: AppColors.cardBackground(context),
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
                        Text(
                          "BMW 5 Series - Luxury",
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // TAGS
                        Row(children: [_tag("Automatic"), _tag("Petrol")]),

                        const SizedBox(height: 10),

                        Text(
                          "₹4,500/day",
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
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

  Widget _tag(String text) => Builder(
    builder: (context) => Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: AppColors.textSecondary(context)),
      ),
    ),
  );
}
