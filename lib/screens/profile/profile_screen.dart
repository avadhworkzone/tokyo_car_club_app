import 'package:flutter/material.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import 'package:tokyo_car_club/screens/auth/login_page.dart';
import '../booking/my_bookings_screen.dart';
import '../saved/saved_cars_screen.dart';
import '../support/support_chat_screen.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background(context),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              SlideTransition(
                position: _slideAnimation,
                child: AppText(
                  StringUtils.t('profile'),
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Profile Section
              SlideTransition(
                position: _slideAnimation,
                child: _buildProfileSection(context),
              ),
              const SizedBox(height: 24),
              // Menu Items with staggered animation
              ..._buildAnimatedMenuItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.blueAccent,
                backgroundImage: const AssetImage("assets/images/user.png"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          AppText(
            StringUtils.t('user_name'),
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          AppText(
            StringUtils.t('user_email'),
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.textPrimary(context),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    StringUtils.t('edit_profile'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedMenuItems() {
    final menuItems = [
      {
        'title': StringUtils.t('payment_methods'),
        'icon': Icons.payment,
        'onTap': () {},
        'isLogout': false,
      },
      {
        'title': StringUtils.t('help_center'),
        'icon': Icons.help_center,
        'onTap': () {},
        'isLogout': false,
      },
      {
        'title': StringUtils.t('support'),
        'icon': Icons.support_agent,
        'onTap': () => _navigateToSupport(context),
        'isLogout': false,
      },
      {
        'title': StringUtils.t('settings'),
        'icon': Icons.settings,
        'onTap': () => _navigateToSettings(context),
        'isLogout': false,
      },
      {
        'title': StringUtils.t('logout'),
        'icon': Icons.logout,
        'onTap': () => _showLogoutDialog(context),
        'isLogout': true,
      },
    ];

    return menuItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          final delay = index * 0.1;
          final animationValue = Curves.easeOutCubic.transform(
            (_slideController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
          );
          return Transform.translate(
            offset: Offset(0, 30 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: _buildMenuItem(
                context,
                item['title'] as String,
                item['icon'] as IconData,
                item['onTap'] as VoidCallback,
                isLogout: item['isLogout'] as bool,
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add haptic feedback
            // HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isLogout
                        ? AppColors.error.withOpacity(0.2)
                        : AppColors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isLogout ? AppColors.error : AppColors.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    title,
                    style: TextStyle(
                      color: isLogout
                          ? AppColors.error
                          : AppColors.textPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textTertiary(context),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToBookings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
    );
  }

  void _navigateToSavedCars(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedCarsScreen()),
    );
  }

  void _navigateToSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupportChatScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            StringUtils.t('logout'),
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            StringUtils.t('logout_confirmation'),
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 14,
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                StringUtils.t('cancel'),
                style: TextStyle(
                  color: AppColors.textTertiary(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Logout Button (Blue)
            ElevatedButton(
              onPressed: () {
                _navigateToLogout(context);
                // Navigator.pop(context);
                // Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueAccent,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                StringUtils.t('logout'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
