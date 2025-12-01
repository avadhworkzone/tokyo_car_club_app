import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/core/utils/string_utils.dart';
import 'package:tokyo_car_club/core/constants/app_colors.dart';
import 'package:tokyo_car_club/core/theme/app_theme.dart';
import 'package:tokyo_car_club/core/widgets/app_text.dart';
import '../../theme/theme_cubit.dart';
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
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
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
    return BlocProvider(
      create: (context) =>
          SettingsBloc(context.read<ThemeCubit>())..add(LoadSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringUtils.t('settings')),
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
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              );
            }

            if (state is SettingsLoaded) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: _buildAnimatedSettingsItems(state, context)),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedSettingsItems(SettingsLoaded state, BuildContext blocContext) {
    final items = [
      {
        'type': 'toggle',
        'title': StringUtils.t('dark_mode'),
        'icon': Icons.dark_mode,
        'value': state.isDarkMode,
      },
      {
        'type': 'menu',
        'title': StringUtils.t('language'),
        'icon': Icons.language,
        'trailing': state.language,
        'onTap': () => _showLanguageDialog(context, state.language, blocContext.read<SettingsBloc>()),
      },
      {
        'type': 'menu',
        'title': StringUtils.t('change_password'),
        'icon': Icons.lock,
        'onTap': () => _showChangePasswordDialog(context),
      },
      {
        'type': 'menu',
        'title': StringUtils.t('privacy_policy'),
        'icon': Icons.privacy_tip,
        'onTap': () {},
      },
      {
        'type': 'menu',
        'title': StringUtils.t('delete_account'),
        'icon': Icons.delete_forever,
        'onTap': () => _showDeleteAccountDialog(context),
        'isDestructive': true,
      },
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
                        blocContext.read<SettingsBloc>().add(
                          ToggleDarkModeEvent(value),
                        );
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
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 14,
                              ),
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                        ? Colors.red.withOpacity(0.2)
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? Colors.red
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailing != null) ...[trailing, const SizedBox(width: 8)],
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage, SettingsBloc settingsBloc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            StringUtils.t('select_language'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(dialogContext, 'English', currentLanguage, settingsBloc),
              _buildLanguageOption(dialogContext, '日本語', currentLanguage, settingsBloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String currentLanguage,
    SettingsBloc settingsBloc,
  ) {
    final isSelected = language == currentLanguage;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          settingsBloc.add(ChangeLanguageEvent(language));
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
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
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
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            StringUtils.t('change_password'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            StringUtils.t('change_password_message'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringUtils.t('change'),
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            StringUtils.t('delete_account'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            StringUtils.t('delete_account_warning'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringUtils.t('delete'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
