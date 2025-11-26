import 'package:flutter/material.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/widgets/app_button.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'logic/booking_bloc.dart';
import 'logic/booking_event.dart';
import 'logic/booking_state.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Checkmark
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.royalBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Title
              AppText(
                StringUtils.t('booking_confirmed'),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle
              AppText(
                StringUtils.t('booking_details_sent'),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.platinum),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: StringUtils.t('view_my_bookings'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyBookingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),
      appBar: AppBar(
        title: Text(
          StringUtils.t('booking_details'),
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: const Color(0xFF0A0D14),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: AppColors.white,
              child: Icon(Icons.arrow_back, color: AppColors.black),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      booking['carImage'],
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    booking['carName'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  AppText(
                    booking['price'],
                    style: TextStyle(fontSize: 16, color: AppTheme.softCyan),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Booking ID
            _buildDetailRow(StringUtils.t('booking_id'), booking['id']),

            const SizedBox(height: 16),

            // Dates
            _buildDetailRow(
              'Dates',
              '${booking['startDate']} - ${booking['endDate']}',
            ),

            const SizedBox(height: 16),

            // Pickup Location
            _buildDetailRow(
              StringUtils.t('pickup_location'),
              booking['location'],
            ),

            const SizedBox(height: 16),

            // Drop-off Location
            _buildDetailRow(
              StringUtils.t('dropoff_location'),
              booking['location'],
            ),

            const SizedBox(height: 20),

            // Map Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 40, color: AppColors.white),
                    SizedBox(height: 8),
                    Text(
                      StringUtils.t('location_map'),
                      style: TextStyle(color: AppColors.white70, fontSize: 16),
                    ),
                    Text(
                      StringUtils.t('tap_to_view_map'),
                      style: const TextStyle(
                        color: AppColors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Payment Mode
            _buildDetailRow(StringUtils.t('payment_mode'), 'Credit Card'),

            const SizedBox(height: 30),

            // Download Invoice Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(StringUtils.t('invoice_downloaded')),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  StringUtils.t('download_invoice'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(label, style: TextStyle(color: AppTheme.platinum)),
          AppText(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc()..add(LoadBookingsEvent()),
      child: Container(
        color: AppColors.darkBackground,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppText(
                StringUtils.t('my_bookings'),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Content
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is BookingError) {
                    return Center(child: AppText(state.message));
                  }

                  if (state is BookingLoaded) {
                    return Column(
                      children: [
                        // Tabs
                        Container(
                          height: 44,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildTab(
                                context,
                                'upcoming',
                                state.currentFilter,
                              ),
                              _buildTab(
                                context,
                                'ongoing',
                                state.currentFilter,
                              ),
                              _buildTab(
                                context,
                                'completed',
                                state.currentFilter,
                              ),
                              _buildTab(
                                context,
                                'cancelled',
                                state.currentFilter,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bookings List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.bookings.length,
                            itemBuilder: (context, index) {
                              final booking = state.bookings[index];
                              return _buildBookingCard(context, booking);
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String status, String currentFilter) {
    final isSelected = status == currentFilter;
    return GestureDetector(
      onTap: () {
        context.read<BookingBloc>().add(FilterBookingsEvent(status));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : const Color(0xFF141820),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.white24, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: isSelected ? AppColors.black : AppColors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          child: Text(StringUtils.t(status)),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  booking['carImage'],
                  width: 60,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      booking['carName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    AppText(
                      '${booking['startDate']} - ${booking['endDate']}',
                      style: TextStyle(color: AppTheme.platinum, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: booking['status'] == 'upcoming'
                      ? AppTheme.royalBlue
                      : AppTheme.platinum,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppText(
                  StringUtils.t(booking['status']),
                  style: const TextStyle(fontSize: 10, color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                booking['price'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailsScreen(booking: booking),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.white, width: 1.2),
                  ),
                  child: const Text(
                    "View",
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
