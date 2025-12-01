import 'package:flutter/material.dart';
import 'app.dart';
import 'theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme cubit with saved preferences
  final themeCubit = await ThemeCubit.create();
  
  runApp(TokyoCarClubApp(themeCubit: themeCubit));
}
