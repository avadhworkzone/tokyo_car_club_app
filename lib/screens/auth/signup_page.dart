import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_colors.dart';
import 'logic/auth_bloc.dart';
import 'logic/auth_event.dart';
import 'logic/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String? nameError;
  String? emailError;
  String? passError;

  bool get isValid =>
      nameError == null &&
      emailError == null &&
      passError == null &&
      name.text.isNotEmpty &&
      email.text.isNotEmpty &&
      password.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // ⭐ Same background color as Login screen
        backgroundColor: AppColors.background(context),
        resizeToAvoidBottomInset: false,

        body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthSuccess) Navigator.pop(context);
        },

        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                // ⭐ Page Title (White)
                Text(
                  "Create Account",
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Join the club and rent luxury cars anytime",
                  style: TextStyle(color: AppColors.textSecondary(context), fontSize: 15),
                ),

                const SizedBox(height: 40),

                // ⭐ Card container (same lighter navy as login)
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
                      // Full Name
                      AppTextField(
                        hintText: "Full Name",
                        controller: name,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.textPrimary(context),
                        ),
                        hintColor: AppColors.textTertiary(context),
                        textColor: AppColors.textPrimary(context),
                        onChanged: (v) =>
                            setState(() => nameError = Validators.name(v)),
                      ),
                      if (nameError != null) _error(nameError!),

                      const SizedBox(height: 16),

                      // Email
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

                      const SizedBox(height: 16),

                      // Password
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

                      // ⭐ Button (White background, Black text)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isValid
                              ? () {
                                  // context.read<AuthBloc>().add(
                                  //   SignUpEvent(
                                  //     name.text.trim(),
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
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

                const SizedBox(height: 20),

                // Back to login link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Already have an account? Sign In",
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        decoration: TextDecoration.underline,
                        fontSize: 15,
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

  // ⭐ Error text
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
