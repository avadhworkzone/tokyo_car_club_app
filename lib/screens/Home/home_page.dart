import 'package:flutter/material.dart';
import 'package:tokyo_car_club/screens/Home/car_detail.dart';
import 'package:tokyo_car_club/search_result.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import '../booking/my_bookings_screen.dart';
import '../saved/saved_cars_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedCategory = 0;
  late int bottomIndex;
  late AnimationController _animationController;
  late AnimationController _topBarController;
  late AnimationController _bannerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _topBarFade;
  late Animation<Offset> _topBarSlide;
  late Animation<double> _bannerScale;
  late Animation<double> _bannerFade;

  final categories = ["SUV", "Sedan", "Luxury", "Convertible", "Electric"];

  @override
  void initState() {
    super.initState();
    bottomIndex = widget.initialIndex;
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _topBarController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bannerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _topBarFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _topBarController, curve: Curves.easeOut),
    );
    _topBarSlide = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _topBarController, curve: Curves.easeOutBack),
        );

    _bannerScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bannerController, curve: Curves.elasticOut),
    );
    _bannerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bannerController, curve: Curves.easeOut),
    );

    _topBarController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _bannerController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _topBarController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bottomIndex != 0) {
          setState(() => bottomIndex = 0);
          return false;
        }
        return await _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.cardBackground(context),
          currentIndex: bottomIndex,
          selectedItemColor: AppColors.accent(context),
          unselectedItemColor: AppColors.textTertiary(context),
          type: BottomNavigationBarType.fixed,
          onTap: (i) => setState(() => bottomIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_filled),
              label: StringUtils.t('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore),
              label: StringUtils.t('explore'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month),
              label: StringUtils.t('bookings'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: StringUtils.t('saved'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: StringUtils.t('profile'),
            ),
          ],
        ),

        body: SafeArea(child: _getBodyWidget()),
      ),
    );
  }

  Widget _getBodyWidget() {
    switch (bottomIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const ExploreScreen();
      case 2:
        return const MyBookingsScreen();
      case 3:
        return const SavedCarsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ TOP BAR
          FadeTransition(
            opacity: _topBarFade,
            child: SlideTransition(
              position: _topBarSlide,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User avatar
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.5 + (0.5 * value),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage("assets/images/user.png"),
                        ),
                      );
                    },
                  ),

                  // Location selector
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.textPrimary(context),
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                StringUtils.t('mumbai_india'),
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.textPrimary(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Notification with blue dot
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: (1 - value) * 0.5,
                        child: Transform.scale(
                          scale: 0.7 + (0.3 * value),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  color: AppColors.textPrimary(context),
                                  size: 28,
                                ),
                                Positioned(
                                  right: 0,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(
                                      milliseconds: 1200,
                                    ),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, dotValue, child) {
                                      return Transform.scale(
                                        scale: dotValue,
                                        child: Container(
                                          height: 8,
                                          width: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.blueAccent,
                                            shape: BoxShape.circle,
                                          ),
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
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ⭐ SEARCH BOX
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SearchResultsPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.textSecondary(context),
                      ),
                      SizedBox(width: 10),
                      Text(
                        StringUtils.t('search_placeholder'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // ⭐ CATEGORIES (HORIZONTAL PILLS)
          FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final isActive = selectedCategory == i;

                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (i * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.accent(context)
                                : AppColors.cardBackground(context),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.textTertiary(
                                context,
                              ).withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent(
                                        context,
                                      ).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                              fontSize: 14,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                            child: Center(child: Text(categories[i])),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ⭐ FEATURED CAR BANNER
          FadeTransition(
            opacity: _bannerFade,
            child: ScaleTransition(
              scale: _bannerScale,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background(context),
                      AppColors.gradientEnd(context),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/car.png"),
                    fit: BoxFit.cover,
                    opacity: 0.50,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blueAccent.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1200),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(-20 * (1 - value), 0),
                            child: Opacity(
                              opacity: value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  StringUtils.t('discount_20'),
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1400),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(-30 * (1 - value), 0),
                            child: Opacity(
                              opacity: value,
                              child: Text(
                                StringUtils.t('bmw_m2'),
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ⭐ POPULAR CARS TITLE
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(-20 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: Text(
                    StringUtils.t('popular_cars'),
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          // ⭐ POPULAR CARS LIST
          Column(
            children: List.generate(3, (i) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 800 + (i * 200)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 600 + (i * 100)),
                        curve: Curves.easeOutBack,
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground(context),
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
                            // Car Image
                            Container(
                              height: 80,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/car.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Car Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringUtils.t('audi_a6'),
                                    style: TextStyle(
                                      color: AppColors.textPrimary(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        StringUtils.t('rating_48'),
                                        style: TextStyle(
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    StringUtils.t('price_per_day'),
                                    style: TextStyle(
                                      color: AppColors.textPrimary(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // View details button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => const CarDetailsPage(),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return SlideTransition(
                                            position:
                                                Tween<Offset>(
                                                  begin: const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeOutCubic,
                                                  ),
                                                ),
                                            child: child,
                                          );
                                        },
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
                                  border: Border.all(
                                    color: AppColors.textPrimary(context),
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  StringUtils.t('view'),
                                  style: TextStyle(
                                    color: AppColors.textPrimary(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                StringUtils.t('Exit app'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                StringUtils.t('Sure to exit app'),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    StringUtils.t('cancel'),
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    StringUtils.t('exit'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
