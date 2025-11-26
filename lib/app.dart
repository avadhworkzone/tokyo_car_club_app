import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/screens/auth/login_page.dart';
import 'package:tokyo_car_club/screens/splash/splash_screen.dart';


import 'core/theme/app_theme.dart';
import 'localization/locale_cubit.dart';
import 'localization/locale_state.dart';

import 'screens/auth/data/auth_repository.dart';
import 'screens/auth/logic/auth_bloc.dart';
import 'theme/theme_cubit.dart';
import 'theme/theme_state.dart';

import 'core/utils/string_utils.dart';

class TokyoCarClubApp extends StatelessWidget {
  const TokyoCarClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository()),
        ),

      ],

      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final themeData = themeState.themeMode == AppThemeMode.light
                  ? AppTheme.lightTheme
                  : AppTheme.darkTheme;

              return MaterialApp(
                title: "Tokyo Car Club",
                debugShowCheckedModeBanner: false,
                theme: themeData,
                // ⭐ Forcing rebuild when language changes
                key: ValueKey(localeState.language),
                home: const SplashScreen(),
                onGenerateTitle: (_) => StringUtils.t("app_title"),
              );
            },
          );
        },
      ),
    );
  }
}
