import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widgets/auth/auth_action_button.dart';
import '../widgets/auth/auth_bottom_action.dart';
import '../widgets/auth/custom_text_field.dart';
import '../widgets/auth/password_text_field.dart';
import '../widgets/auth/welcome_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordObscure = true;
  bool _confirmPasswordObscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.primary,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24.0),
                  const WelcomeMessage(
                    firstText: 'Halo! Mari bergabung\ndengan ',
                  ),
                  const SizedBox(height: 24.0),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 36.0, horizontal: 32.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Buat Akun',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w800,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48.0),
                          CustomTextField(
                            inputType: TextInputType.name,
                            controller: _usernameController,
                            labelText: 'Username',
                            hintText: 'Masukan Username-mu',
                          ),
                          const SizedBox(height: 18.0),
                          CustomTextField(
                            inputType: TextInputType.emailAddress,
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Masukan Email-mu',
                          ),
                          const SizedBox(height: 18.0),
                          PasswordTextField(
                            controller: _passwordController,
                            obscureText: _passwordObscure,
                            togglePasswordVisibility: () {
                              setState(() {
                                _passwordObscure = !_passwordObscure;
                              });
                            },
                            labelText: 'Kata Sandi',
                            hintText: 'Masukkan Kata Sandi-mu',
                          ),
                          const SizedBox(height: 18.0),
                          PasswordTextField(
                            controller: _confirmPasswordController,
                            obscureText: _confirmPasswordObscure,
                            togglePasswordVisibility: () {
                              setState(() {
                                _confirmPasswordObscure =
                                    !_confirmPasswordObscure;
                              });
                            },
                            labelText: 'Konfirmasi Kata Sandi',
                            hintText: 'Masukkan Kata Sandi-mu lagi',
                          ),
                          const SizedBox(height: 32.0),
                          AuthActionButton(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            confirmPasswordController: _confirmPasswordController,
                            usernameController: _usernameController,
                            buttonText: 'Buat',
                            action: (String email, String password, [String? confirmPassword, String? username]) {
                              return Provider.of<AuthProvider>(context, listen: false)
                                  .createUserWithEmailPassword(
                                  email, password, confirmPassword, username);
                            },
                            onSuccess: _navigateToLogin,
                          ),
                          const Spacer(),
                          const SizedBox(height: 36.0),
                          FormActionRow(
                            message: 'Sudah punya akun Mealty?',
                            buttonText: 'Ayo Masuk',
                            onButtonPressed: () {
                              context.pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
