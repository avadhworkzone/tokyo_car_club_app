import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import 'logic/settings_bloc.dart';
import 'logic/settings_event.dart';
import 'logic/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
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
    return BlocProvider(
      create: (context) => SettingsBloc()..add(LoadSettingsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: Text(
            StringUtils.t('settings'),
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
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SettingsError) {
              return Center(
                child: AppText(
                  state.message,
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            if (state is SettingsLoaded) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: _buildAnimatedSettingsItems(state),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedSettingsItems(SettingsLoaded state) {
    final items = [
      {'type': 'toggle', 'title': StringUtils.t('dark_mode'), 'icon': Icons.dark_mode, 'value': state.isDarkMode},
      {'type': 'menu', 'title': StringUtils.t('language'), 'icon': Icons.language, 'trailing': state.language, 'onTap': () => _showLanguageDialog(context, state.language)},
      {'type': 'menu', 'title': StringUtils.t('change_password'), 'icon': Icons.lock, 'onTap': () => _showChangePasswordDialog(context)},
      {'type': 'menu', 'title': StringUtils.t('privacy_policy'), 'icon': Icons.privacy_tip, 'onTap': () {}},
      {'type': 'menu', 'title': StringUtils.t('delete_account'), 'icon': Icons.delete_forever, 'onTap': () => _showDeleteAccountDialog(context), 'isDestructive': true},
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          final delay = index * 0.12;
          final animationValue = Curves.easeOutCubic.transform(
            (_slideController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
          );
          return Transform.translate(
            offset: Offset(0, 40 * (1 - animationValue)),
            child: Opacity(
              opacity: animationValue,
              child: item['type'] == 'toggle'
                  ? _buildToggleItem(
                      context,
                      item['title'] as String,
                      item['icon'] as IconData,
                      item['value'] as bool,
                      (value) {
                        context.read<SettingsBloc>().add(ToggleDarkModeEvent(value));
                      },
                    )
                  : _buildMenuItem(
                      context,
                      item['title'] as String,
                      item['icon'] as IconData,
                      item['onTap'] as VoidCallback,
                      trailing: item['trailing'] != null
                          ? Text(
                              item['trailing'] as String,
                              style: TextStyle(color: AppTheme.platinum, fontSize: 14),
                            )
                          : null,
                      isDestructive: item['isDestructive'] as bool? ?? false,
                    ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildToggleItem(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.blueAccent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? AppColors.error.withOpacity(0.2)
                        : AppColors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? AppColors.error : AppColors.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    title,
                    style: TextStyle(
                      color: isDestructive ? AppColors.error : AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  trailing,
                  const SizedBox(width: 8),
                ],
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.white54,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.navy,
          title: Text(
            StringUtils.t('select_language'),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, 'English', currentLanguage),
              _buildLanguageOption(context, '日本語', currentLanguage),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, String currentLanguage) {
    final isSelected = language == currentLanguage;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<SettingsBloc>().add(ChangeLanguageEvent(language));
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language,
                  style: TextStyle(
                    color: isSelected ? AppColors.blueAccent : AppColors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, color: AppColors.blueAccent, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.navy,
          title: Text(
            StringUtils.t('change_password'),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Text(
            StringUtils.t('change_password_message'),
            style: TextStyle(color: AppTheme.platinum),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringUtils.t('cancel'),
                style: const TextStyle(color: AppColors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringUtils.t('change'),
                style: const TextStyle(color: AppColors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.navy,
          title: Text(
            StringUtils.t('delete_account'),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Text(
            StringUtils.t('delete_account_warning'),
            style: TextStyle(color: AppTheme.platinum),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringUtils.t('cancel'),
                style: const TextStyle(color: AppColors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringUtils.t('delete'),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}