import 'package:flutter/material.dart';
import 'package:mealty/widgets/auth_bottom_action.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import '../widgets/welcome_message.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      padding: const EdgeInsets.only(
                          left: 32.0, right: 32.0, top: 36.0, bottom: 24.0),
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
                          const SizedBox(height: 24.0),
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Masukkan Email-mu',
                          ),
                          const SizedBox(height: 16.0),
                          PasswordTextField(
                            controller: _passwordController,
                            obscureText: _passwordObscure,
                            togglePasswordVisibility: () {
                              setState(() {
                                _passwordObscure = !_passwordObscure;
                              });
                            },
                          ),
                          const SizedBox(height: 28.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {

                              },
                              child: Text(
                                'Masuk',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'atau',
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
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Implement login with Google logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                foregroundColor: Theme.of(context).colorScheme.onBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                  )
                                )
                              ),
                              icon: Image.asset(
                                'images/google_icon.png',
                                width: 18,
                                height: 18,
                              ),
                              label: Text(
                                'Masuk dengan Google',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          FormActionRow(
                            message: 'Belum punya Akun?',
                            buttonText: 'Daftar disini!',
                            onButtonPressed: () {
                              // Handle registration navigation
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
