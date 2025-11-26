import 'package:flutter/material.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import '../Home/car_detail.dart';

class FilteredCarsScreen extends StatefulWidget {
  final String title;
  final String filterType; // 'type', 'location'
  final String filterValue;
  
  const FilteredCarsScreen({
    super.key, 
    required this.title,
    required this.filterType,
    required this.filterValue,
  });

  @override
  State<FilteredCarsScreen> createState() => _FilteredCarsScreenState();
}

class _FilteredCarsScreenState extends State<FilteredCarsScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _contentFade;
  
  String selectedSort = 'Price: Low to High';
  final sortOptions = ['Price: Low to High', 'Price: High to Low', 'Rating', 'Newest'];
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSortOptions(),
            Expanded(child: _buildCarsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      widget.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppText(
                      '${_getFilteredCars().length} cars available',
                      style: TextStyle(
                        color: AppTheme.platinum,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return FadeTransition(
      opacity: _contentFade,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sortOptions.length,
          itemBuilder: (context, index) {
            final option = sortOptions[index];
            final isSelected = selectedSort == option;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: GestureDetector(
                      onTap: () => setState(() => selectedSort = option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.blueAccent : AppTheme.navy,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected ? null : Border.all(color: AppColors.white24),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.white70,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCarsList() {
    final cars = _getSortedCars();
    
    return FadeTransition(
      opacity: _contentFade,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(30 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const CarDetailsPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.navy,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage("assets/images/car.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car['name'] ?? '',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  car['type'] ?? '',
                                  style: TextStyle(
                                    color: AppTheme.platinum,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: AppColors.amber, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      car['rating'] ?? '',
                                      style: const TextStyle(color: AppColors.white70, fontSize: 12),
                                    ),
                                    const Spacer(),
                                    Text(
                                      car['price'] ?? '',
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: AppColors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getFilteredCars() {
    final allCars = [
      {'name': 'BMW X5', 'type': 'SUV', 'rating': '4.8', 'price': '₹5,200', 'location': 'Tokyo Station'},
      {'name': 'Audi A6', 'type': 'Sedan', 'rating': '4.7', 'price': '₹4,800', 'location': 'Shibuya'},
      {'name': 'Mercedes S-Class', 'type': 'Luxury', 'rating': '4.9', 'price': '₹8,500', 'location': 'Harajuku'},
      {'name': 'Tesla Model 3', 'type': 'Electric', 'rating': '4.6', 'price': '₹6,200', 'location': 'Tokyo Station'},
      {'name': 'Toyota Prius', 'type': 'Electric', 'rating': '4.5', 'price': '₹3,500', 'location': 'Shibuya'},
      {'name': 'Honda CR-V', 'type': 'SUV', 'rating': '4.4', 'price': '₹4,200', 'location': 'Harajuku'},
      {'name': 'BMW 7 Series', 'type': 'Luxury', 'rating': '4.8', 'price': '₹7,800', 'location': 'Tokyo Station'},
      {'name': 'Audi Q7', 'type': 'SUV', 'rating': '4.7', 'price': '₹6,500', 'location': 'Shibuya'},
    ];

    if (widget.filterType == 'type') {
      return allCars.where((car) => car['type'] == widget.filterValue).toList();
    } else if (widget.filterType == 'location') {
      return allCars.where((car) => car['location'] == widget.filterValue).toList();
    }
    return allCars;
  }

  List<Map<String, String>> _getSortedCars() {
    final cars = _getFilteredCars();
    
    switch (selectedSort) {
      case 'Price: Low to High':
        cars.sort((a, b) => _extractPrice(a['price'] ?? '').compareTo(_extractPrice(b['price'] ?? '')));
        break;
      case 'Price: High to Low':
        cars.sort((a, b) => _extractPrice(b['price'] ?? '').compareTo(_extractPrice(a['price'] ?? '')));
        break;
      case 'Rating':
        cars.sort((a, b) => double.parse(b['rating'] ?? '0').compareTo(double.parse(a['rating'] ?? '0')));
        break;
    }
    return cars;
  }

  int _extractPrice(String price) {
    return int.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }
}