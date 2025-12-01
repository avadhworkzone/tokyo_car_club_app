import 'package:flutter/material.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import '../booking/booking_confirmation_screen.dart';

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({super.key});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage>
    with TickerProviderStateMixin {
  bool isFavorite = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late AnimationController _favoriteController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );
    _colorAnimation = ColorTween(begin: AppColors.white54, end: Colors.red)
        .animate(
          CurvedAnimation(parent: _favoriteController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    if (isFavorite) {
      _favoriteController.forward();
    } else {
      _favoriteController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),

      body: CustomScrollView(
        slivers: [
          // HERO IMAGE WITH BUTTONS
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background(context),
            leading: _circleButton(
              Icons.arrow_back,
              () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: AnimatedBuilder(
                    animation: _favoriteController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: CircleAvatar(
                          backgroundColor: AppColors.cardBackground(context),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : AppColors.textPrimary(context),
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset("assets/images/car.png", fit: BoxFit.cover),
                  Container(
                    color: AppColors.background(context).withOpacity(0.4),
                  ),
                ],
              ),
            ),
          ),

          // DETAILS SECTION
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBackground(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringUtils.t('bmw_5_series'),
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.accent(context),
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        StringUtils.t('reviews_120'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ICON ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoIcon(Icons.event_seat, StringUtils.t('seats_5')),
                      _infoIcon(Icons.work, StringUtils.t('bags_2')),
                      _infoIcon(Icons.settings, StringUtils.t('automatic')),
                      _infoIcon(
                        Icons.battery_charging_full,
                        StringUtils.t('petrol'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // DESCRIPTION
                  Text(
                    StringUtils.t('bmw_description'),
                    style: TextStyle(color: AppColors.textSecondary(context)),
                  ),

                  const SizedBox(height: 24),

                  // AVAILABILITY SECTION
                  Text(
                    StringUtils.t('availability'),
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DATE PICKER
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: AppColors.accent(context),
                                surface: AppColors.cardBackground(context),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textSecondary(
                            context,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.textPrimary(context),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : StringUtils.t('select_date'),
                            style: TextStyle(
                              color: selectedDate != null
                                  ? AppColors.textPrimary(context)
                                  : AppColors.textSecondary(context),
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textTertiary(context),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // TIME PICKER
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        hourLabelText: 'Hour',
                        minuteLabelText: 'Minute',
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: false),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppColors.accent(context),
                                  surface: AppColors.cardBackground(context),
                                ),
                              ),
                              child: child!,
                            ),
                          );
                        },
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textSecondary(
                            context,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.textPrimary(context),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : StringUtils.t('select_time'),
                            style: TextStyle(
                              color: selectedTime != null
                                  ? AppColors.textPrimary(context)
                                  : AppColors.textSecondary(context),
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textTertiary(context),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // PRICE
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground(context),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringUtils.t('price_4500_day'),
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          StringUtils.t('deposit_10000'),
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
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
                          MaterialPageRoute(
                            builder: (_) => const BookingSummaryPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: AppColors.accent(context),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        StringUtils.t('continue_booking'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Builder(
          builder: (context) => CircleAvatar(
            backgroundColor: AppColors.surface(context),
            child: Icon(icon, color: AppColors.textPrimary(context)),
          ),
        ),
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
        Icon(icon, color: AppColors.textPrimary(context)),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ⭐ BOOKING SUMMARY SCREEN
class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage>
    with TickerProviderStateMixin {
  bool insuranceSelected = false;
  String selectedPayment = "Credit Card";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
        title: Text(
          StringUtils.t('booking_summary'),
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CAR DETAILS
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(StringUtils.t('car_details')),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground(context),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/car.png",
                              height: 80,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringUtils.t('bmw_5_series'),
                                  style: TextStyle(
                                    color: AppColors.textPrimary(context),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  StringUtils.t('luxury_sedan_auto_petrol'),
                                  style: TextStyle(
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  StringUtils.t('price_4500_day'),
                                  style: TextStyle(
                                    color: AppColors.textPrimary(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // PICKUP DATE & TIME
            _title(StringUtils.t('pickup_date_time')),
            _box("18 Jan 2025, 10:00 AM"),

            const SizedBox(height: 18),

            // DROP-OFF DATE & TIME
            _title(StringUtils.t('dropoff_date_time')),
            _box("20 Jan 2025, 05:00 PM"),

            const SizedBox(height: 24),

            // LOCATION MAP CARD
            _title(StringUtils.t('pickup_location_text')),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.textPrimary(context),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        StringUtils.t('mumbai_airport_t2'),
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.background(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        StringUtils.t('map_view'),
                        style: TextStyle(
                          color: AppColors.textTertiary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TOTAL FARE CALCULATOR
            _title(StringUtils.t('total_fare')),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _fareRow(StringUtils.t('car_rental_2_days'), "₹9,000"),
                  _fareRow(StringUtils.t('taxes_fees'), "₹1,200"),
                  if (insuranceSelected)
                    _fareRow(StringUtils.t('insurance'), "₹500"),
                  Divider(
                    color: AppColors.textSecondary(context).withOpacity(0.3),
                  ),
                  _fareRow(
                    StringUtils.t('total'),
                    "₹${insuranceSelected ? '10,700' : '10,200'}",
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // INSURANCE ADDONS
            _title(StringUtils.t('insurance_optional')),
            GestureDetector(
              onTap: () =>
                  setState(() => insuranceSelected = !insuranceSelected),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: insuranceSelected
                        ? AppColors.accent(context)
                        : AppColors.textSecondary(context).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      insuranceSelected
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: insuranceSelected
                          ? AppColors.accent(context)
                          : AppColors.textSecondary(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        StringUtils.t('comprehensive_insurance'),
                        style: TextStyle(color: AppColors.textPrimary(context)),
                      ),
                    ),
                    Text(
                      "₹500",
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // PAYMENT METHOD SELECTOR
            _title(StringUtils.t('payment_method')),
            Column(
              children: [
                _paymentOption(
                  StringUtils.t('credit_debit_card'),
                  Icons.credit_card,
                ),
                _paymentOption(
                  StringUtils.t('upi'),
                  Icons.account_balance_wallet,
                ),
                _paymentOption(StringUtils.t('wallet'), Icons.wallet),
                _paymentOption(StringUtils.t('cash_at_pickup'), Icons.money),
              ],
            ),

            const SizedBox(height: 32),

            // CTA BUTTON
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const PaymentScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position:
                                        Tween<Offset>(
                                          begin: const Offset(0, 1),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          ),
                                        ),
                                    child: child,
                                  ),
                                );
                              },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      elevation: 8,
                      shadowColor: AppColors.white.withOpacity(0.3),
                    ),
                    child: Text(
                      StringUtils.t('proceed_to_payment'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _box(String text) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.cardBackground(context),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      text,
      style: TextStyle(color: AppColors.textSecondary(context)),
    ),
  );

  Widget _fareRow(String label, String amount, {bool isTotal = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isTotal ? AppColors.white : AppColors.white70,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );

  Widget _paymentOption(String title, IconData icon) => GestureDetector(
    onTap: () => setState(() => selectedPayment = title),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selectedPayment == title
              ? AppColors.accent(context)
              : AppColors.textSecondary(context).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary(context)),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Icon(
            selectedPayment == title
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: selectedPayment == title
                ? AppColors.accent(context)
                : AppColors.textSecondary(context),
          ),
        ],
      ),
    ),
  );
}

// ⭐ PAYMENT SCREEN
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  final cardNumber = TextEditingController();
  final expiryDate = TextEditingController();
  final cvv = TextEditingController();
  final cardHolder = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: AppColors.surface(context),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary(context),
                  size: 20,
                ),
              ),
            ),
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
          title: Text(
            "Payment",
            style: TextStyle(color: AppColors.textPrimary(context)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PAYMENT METHODS
              Text(
                "Select Payment Method",
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // PAYMENT OPTIONS
              _paymentMethodCard("Credit/Debit Card", Icons.credit_card, true),
              _paymentMethodCard(
                "UPI Payment",
                Icons.account_balance_wallet,
                false,
              ),
              _paymentMethodCard("Digital Wallet", Icons.wallet, false),
              _paymentMethodCard("Cash at Pickup", Icons.money, false),

              const SizedBox(height: 24),

              // CARD FORM
              Text(
                "Card Details",
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accent(context),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent(context).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _cardField(
                          "Card Number",
                          "1234 5678 9012 3456",
                          cardNumber,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _cardField("MM/YY", "12/25", expiryDate),
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: _cardField("CVV", "123", cvv)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _cardField("Cardholder Name", "John Doe", cardHolder),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ORDER SUMMARY
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _summaryRow("BMW 5 Series (2 days)", "₹9,000"),
                    _summaryRow("Taxes & Fees", "₹1,200"),
                    Divider(
                      color: AppColors.textSecondary(context).withOpacity(0.3),
                    ),
                    _summaryRow("Total Amount", "₹10,200", isTotal: true),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // PAY BUTTON
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BookingConfirmationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent(context),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          elevation: 12,
                          shadowColor: AppColors.accent(
                            context,
                          ).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Pay ₹10,200",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethodCard(String title, IconData icon, bool isSelected) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.accent(context)
                : AppColors.textSecondary(context).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary(context)),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? AppColors.accent(context)
                  : AppColors.textSecondary(context),
            ),
          ],
        ),
      );

  Widget _cardField(
    String label,
    String hint,
    TextEditingController controller,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        style: TextStyle(color: AppColors.textPrimary(context)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textTertiary(context)),
          filled: true,
          fillColor: AppColors.background(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    ],
  );

  Widget _summaryRow(String label, String amount, {bool isTotal = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isTotal
                    ? AppColors.textPrimary(context)
                    : AppColors.textSecondary(context),
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
}
