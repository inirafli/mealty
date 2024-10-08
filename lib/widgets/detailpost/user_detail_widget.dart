import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mealty/utils/data_conversion.dart';

import '../../data/model/user.dart';

class UserProfileWidget extends StatelessWidget {
  final User user;

  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: onPrimary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(user.photoUrl.isNotEmpty
                ? user.photoUrl
                : generateAvatarUrl(user.username)),
          ),
          const SizedBox(width: 18.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
              ),
              Row(
                children: [
                  const Icon(CupertinoIcons.star_fill,
                      color: Colors.orange, size: 15.0),
                  const SizedBox(width: 4.0),
                  Text(
                    '${user.starRating.toStringAsFixed(1)}/5.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.0,
                          color: onBackground,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Row(
                  children: [
                    Icon(MdiIcons.phoneClassic, color: primary, size: 12.0),
                    const SizedBox(width: 6.0),
                    Text(
                      user.phoneNumber.isNotEmpty ? user.phoneNumber : '-',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13.0,
                            color: onBackground,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
