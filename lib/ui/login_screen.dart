import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/widgets/auth/auth_bottom_action.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widgets/auth/auth_action_button.dart';
import '../widgets/auth/custom_text_field.dart';
import '../widgets/auth/google_login_button.dart';
import '../widgets/auth/password_text_field.dart';
import '../widgets/auth/welcome_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToMain() {
    context.go('/main');
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
                    firstText: 'Selamat datang kembali\ndi ',
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
                            'Masuk Akun',
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
                            inputType: TextInputType.emailAddress,
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Masukkan Email-mu',
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
                          const SizedBox(height: 32.0),
                          AuthActionButton(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            buttonText: 'Masuk',
                            action: (String email, String password,
                                [String? confirmPassword, String? username]) {
                              return Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .signInWithEmailPassword(email, password);
                            },
                            onSuccess: _navigateToMain,
                          ),
                          const SizedBox(height: 18.0),
                          Text(
                            '─────   atau   ─────',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 18.0),
                          GoogleSignInButton(onSuccess: _navigateToMain),
                          const Spacer(),
                          const SizedBox(height: 36.0),
                          FormActionRow(
                            message: 'Belum punya Akun?',
                            buttonText: 'Yuk Daftar',
                            onButtonPressed: () {
                              context.go('/login/register');
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
