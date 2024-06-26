import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';

class ProfileInfoEdit extends StatelessWidget {
  const ProfileInfoEdit({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.bold,
        );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: onPrimary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: primary,
          width: 0.75,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
    );

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: onPrimary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44.0,
                    child: TextField(
                      controller: profileProvider.usernameController,
                      decoration: inputDecoration.copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                      style: textStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Telepon',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44.0,
                    child: TextField(
                      controller: profileProvider.phoneNumberController,
                      decoration: inputDecoration.copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                      style: textStyle,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
