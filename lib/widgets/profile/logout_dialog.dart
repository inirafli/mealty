import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/notification_provider.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Konfirmasi Keluar Akun',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onBackground,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20.0,
                  color: onBackground,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            'Kamu akan keluar dari Akun-mu dan kembali ke halaman Login',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: onBackground,
                ),
          ),
          const SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size(double.infinity, 42.0),
                padding: EdgeInsets.zero,
              ),
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final notificationProvider =
                    Provider.of<NotificationProvider>(context, listen: false);
                final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);

                await notificationProvider.cleanNotifications();
                await authProvider.signOut();
                await profileProvider.resetState();

                if (context.mounted) context.go('/login');
              },
              child: Text(
                'Ya, Keluar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onPrimary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
