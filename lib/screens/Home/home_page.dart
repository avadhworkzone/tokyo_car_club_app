import 'package:flutter/material.dart';
import 'package:tokyo_car_club/screens/Home/car_detail.dart';
import 'package:tokyo_car_club/search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  int bottomIndex = 0;

  final categories = [
    "SUV",
    "Sedan",
    "Luxury",
    "Convertible",
    "Electric",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF141820),
        currentIndex: bottomIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => bottomIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Bookings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Saved"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ⭐ TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User avatar
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),

                  // Location selector
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.white, size: 22),
                      SizedBox(width: 4),
                      Text(
                        "Mumbai, India",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),

                  // Notification with blue dot
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none,
                          color: Colors.white, size: 28),
                      Positioned(
                        right: 0,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 24),

              // ⭐ SEARCH BOX
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchResultsPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.black87),
                    SizedBox(width: 10),
                    Text(
                      "Search for cars, brands, or types",
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),


              const SizedBox(height: 22),

              // ⭐ CATEGORIES (HORIZONTAL PILLS)
            // ⭐ CATEGORIES (HORIZONTAL PILLS)
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final isActive = selectedCategory == i;

                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white                   // SELECTED → WHITE
                            : const Color(0xFF141820),       // DEFAULT → NAVY
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white24, // clean subtle border
                          width: 1,
                        ),
                      ),

                      child: Text(
                        categories[i],
                        style: TextStyle(
                          color: isActive
                              ? Colors.black                 // SELECTED → BLACK TEXT
                              : Colors.white,                // DEFAULT → WHITE TEXT
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


              const SizedBox(height: 28),

              // ⭐ FEATURED CAR BANNER
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A0D14), Color(0xFF1A237E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/car.png"),
                    fit: BoxFit.cover,
                    opacity: 0.25,
                  ),
                ),

                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "-20% OFF",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        "BMW M2 Competition",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ⭐ POPULAR CARS TITLE
              const Text(
                "Popular Cars",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              // ⭐ POPULAR CARS LIST
              Column(
                children: List.generate(3, (i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141820),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Car Image
                        Container(
                          height: 80,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image:
                              AssetImage("assets/images/car.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Car Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Audi A6 Sedan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text("4.8",
                                      style: TextStyle(
                                          color: Colors.white70)),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                "₹4,200 / day",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),

                        // View details button
                        InkWell(
                          onTap:  () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => const CarDetailsPage()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.white, width: 1.2),
                            ),
                            child: const Text(
                              "View",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
