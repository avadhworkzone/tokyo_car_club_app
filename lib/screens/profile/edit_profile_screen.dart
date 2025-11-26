import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import 'package:tokyo_car_club/core/widgets/app_button.dart';
import 'logic/profile_bloc.dart';
import 'logic/profile_event.dart';
import 'logic/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileEvent()),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: Text(
            StringUtils.t('edit_profile'),
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(13.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: AppColors.white,
                child: Icon(Icons.arrow_back, color: AppColors.black, size: 20),
              ),
            ),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(StringUtils.t('profile_updated')),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context);
            }
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              _nameController.text = state.profile['name'];
              _emailController.text = state.profile['email'];
              _phoneController.text = state.profile['phone'];
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Image Section
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildProfileImageSection(),
                    ),
                    const SizedBox(height: 32),

                    // Form Fields with staggered animation
                    ..._buildAnimatedFormFields(),
                    const SizedBox(height: 32),

                    // Save Button
                    SlideTransition(
                      position: _slideAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: StringUtils.t('save'),
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                              UpdateProfileEvent(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.blueAccent,
              backgroundImage: const AssetImage("assets/images/user.png"),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkBackground,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppText(
          StringUtils.t('change_photo'),
          style: TextStyle(
            color: AppColors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnimatedFormFields() {
    final fields = [
      {'controller': _nameController, 'label': StringUtils.t('name'), 'icon': Icons.person},
      {'controller': _emailController, 'label': StringUtils.t('email'), 'icon': Icons.email},
      {'controller': _phoneController, 'label': StringUtils.t('phone'), 'icon': Icons.phone},
    ];

    return fields.asMap().entries.map((entry) {
      final index = entry.key;
      final field = entry.value;
      return AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          final delay = index * 0.15;
          final animationValue = Curves.easeOutBack.transform(
            (_slideController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
          );
          return Transform.translate(
            offset: Offset(0, 50 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: Column(
                children: [
                  _buildTextField(
                    controller: field['controller'] as TextEditingController,
                    label: field['label'] as String,
                    icon: field['icon'] as IconData,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppTheme.platinum),
          prefixIcon: Icon(icon, color: AppColors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
