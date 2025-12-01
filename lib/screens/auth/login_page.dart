import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Home/home_page.dart';
import 'logic/auth_bloc.dart';
import 'logic/auth_state.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  String? emailError;
  String? passError;

  bool get isValid =>
      emailError == null &&
      passError == null &&
      email.text.isNotEmpty &&
      password.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // ⭐ SAME BACKGROUND COLOR AS SPLASH (dark navy)
        backgroundColor: AppColors.background(context),
        resizeToAvoidBottomInset: false,

        body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),

                // TITLE TEXT (white)
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  "Sign in to continue renting your dream car",
                  style: TextStyle(color: AppColors.textSecondary(context), fontSize: 15),
                ),

                const SizedBox(height: 40),

                // ⭐ CARD AREA (slightly lighter navy)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      AppTextField(
                        hintText: "Email",
                        controller: email,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.textPrimary(context),
                        ),
                        hintColor: AppColors.textTertiary(context),
                        textColor: AppColors.textPrimary(context),
                        onChanged: (v) =>
                            setState(() => emailError = Validators.email(v)),
                      ),
                      if (emailError != null) _error(emailError!),

                      const SizedBox(height: 18),

                      AppTextField(
                        hintText: "Password",
                        controller: password,
                        isPassword: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppColors.textPrimary(context),
                        ),
                        hintColor: AppColors.textTertiary(context),
                        textColor: AppColors.textPrimary(context),
                        onChanged: (v) =>
                            setState(() => passError = Validators.password(v)),
                      ),
                      if (passError != null) _error(passError!),

                      const SizedBox(height: 26),

                      // ⭐ WHITE BUTTON, BLACK TEXT
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isValid
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                  );
                                  // context.read<AuthBloc>().add(
                                  //   LoginEvent(
                                  //     email.text.trim(),
                                  //     password.text.trim(),
                                  //   ),
                                  // );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent(context),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.textSecondary(context).withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // SIGNUP LINK
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      );
                    },
                    child: Text(
                      "Create a new account",
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }

  // ERROR MESSAGE (red, aligned left)
  Widget _error(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
      ),
    ),
  );
}
