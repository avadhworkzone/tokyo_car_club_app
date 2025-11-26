import 'package:flutter/material.dart';

class CarDetailsPage extends StatelessWidget {
  const CarDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),

      body: Stack(
        children: [
          // HERO IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/car.png",
              fit: BoxFit.cover,
            ),
          ),

          // DARK OVERLAY
          Positioned.fill(
            child: Container(color: Colors.black45),
          ),

          // BACK + SAVE BUTTONS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(Icons.arrow_back, () {
                    Navigator.pop(context);
                  }),

                  _circleButton(Icons.favorite_border, () {}),
                ],
              ),
            ),
          ),

          // DETAILS SECTION
          DraggableScrollableSheet(
            minChildSize: 0.40,
            initialChildSize: 0.42,
            maxChildSize: 0.88,
            builder: (_, controller) => Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFF141820),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),

              child: ListView(
                controller: controller,
                children: [
                  const Text("BMW 5 Series",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text("4.8 (120 Reviews)", style: TextStyle(color: Colors.white70)),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ICON ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _infoIcon(Icons.event_seat, "5 Seats"),
                      _infoIcon(Icons.work, "2 Bags"),
                      _infoIcon(Icons.settings, "Automatic"),
                      _infoIcon(Icons.battery_charging_full, "Petrol"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // DESCRIPTION
                  const Text(
                    "The BMW 5 Series offers luxury, comfort, and performance with a powerful "
                        "engine, premium interiors, and advanced safety features.",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 24),

                  // PRICE
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1F28),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("₹4,500 / day", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text("Deposit: ₹10,000", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // CTA BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BookingSummaryPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Continue to Booking", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

class _infoIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const _infoIcon(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}




// ⭐ BOOKING SUMMARY SCREEN
class BookingSummaryPage extends StatelessWidget {
  const BookingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0D14),
        elevation: 0,
        title: const Text("Booking Summary", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // CAR CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF141820),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("assets/cars/car_sample.png",
                        height: 80, width: 120, fit: BoxFit.cover),
                  ),

                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("BMW 5 Series",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text("Luxury Sedan", style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 6),
                      Text("₹4,500/day", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // DATE + TIME
            _title("Pickup Date & Time"),
            _box("18 Jan 2025, 10:00 AM"),

            const SizedBox(height: 18),

            _title("Drop-off Date & Time"),
            _box("20 Jan 2025, 05:00 PM"),

            const SizedBox(height: 24),

            // LOCATION
            _title("Pickup Location"),
            _box("Mumbai Airport T2"),

            const SizedBox(height: 24),

            // TOTAL FARE
            _title("Total Fare"),
            _box("₹10,200 (includes taxes)"),

            const SizedBox(height: 24),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text("Confirm Booking", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
  );

  Widget _box(String text) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF141820),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white70)),
  );
}