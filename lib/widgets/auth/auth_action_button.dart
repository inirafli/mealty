import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/auth_state.dart';
import '../../provider/auth_provider.dart';
import '../common/custom_loading_indicator.dart';
import '../common/custom_snackbar.dart';

class AuthActionButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? usernameController;
  final String buttonText;
  final Future<void> Function(String email, String password, [String? confirmPassword, String? username]) action;
  final VoidCallback onSuccess;

  const AuthActionButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.confirmPasswordController,
    this.usernameController,
    required this.buttonText,
    required this.action,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authProvider.authState == AuthState.loading
                ? null
                : () async {
              String email = emailController.text.trim();
              String password = passwordController.text.trim();
              String? confirmPassword = confirmPasswordController?.text.trim();
              String? username = usernameController?.text.trim();

              await action(email, password, confirmPassword, username);

              if (!context.mounted) return;

              if (authProvider.authState == AuthState.error) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(CustomSnackBar(
                    contentText: authProvider.errorMessage,
                    context: context,
                  ));
              } else if (authProvider.authState == AuthState.authorized) {
                onSuccess();
              } else if (authProvider.authState == AuthState.registered) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(CustomSnackBar(
                    contentText:
                    'Berhasil melakukan registrasi, silahkan masuk dengan akun',
                    context: context,
                  ));
                onSuccess();
              }
            },
            child: authProvider.authState == AuthState.loading
                ? CustomProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16.0,
              strokeWidth: 2,
            )
                : Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      },
    );
  }
}
