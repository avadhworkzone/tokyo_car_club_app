import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/screens/splash/splash_screen.dart';

import 'core/theme/app_theme.dart';
import 'localization/locale_cubit.dart';
import 'localization/locale_state.dart';
import 'screens/auth/data/auth_repository.dart';
import 'screens/auth/logic/auth_bloc.dart';
import 'screens/Home/logic/home_bloc.dart';
import 'screens/booking/logic/booking_bloc.dart';
import 'core/utils/string_utils.dart';

class TokyoCarClubApp extends StatelessWidget {
  const TokyoCarClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository()),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(),
        ),
        BlocProvider<BookingBloc>(
          create: (_) => BookingBloc(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            title: "Tokyo Car Club",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            key: ValueKey(localeState.language),
            home: const SplashScreen(),
            onGenerateTitle: (_) => StringUtils.t("app_title"),
          );
        },
      ),
    );
  }
}
