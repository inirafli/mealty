import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/auth_state.dart';
import '../../provider/auth_provider.dart';
import '../common/custom_snackbar.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await authProvider.signInWithGoogle();

              if (!context.mounted) return;

              if (authProvider.authState == AuthState.error) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(CustomSnackBar(
                    contentText: authProvider.errorMessage,
                    context: context,
                  ));
              } else if (authProvider.authState == AuthState.authorized) {
                context.go('/main');
              }
            },
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
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ))),
          ),
        );
      },
    );
  }
}
