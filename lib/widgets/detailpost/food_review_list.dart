import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealty/utils/data_conversion.dart';
import 'package:mealty/widgets/common/custom_loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:mealty/provider/food_provider.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:mealty/data/model/user.dart';

class FoodReviewList extends StatelessWidget {
  const FoodReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color secondary = Theme.of(context).colorScheme.secondary;

    final reviews = Provider.of<FoodProvider>(context).reviews;

    if (reviews.isEmpty) {
      return const Center(child: Text('Belum ada Ulasan dari Pembeli'));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return FutureBuilder<User>(
          future: FirestoreService().getUser(review.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomProgressIndicator(
                  color: primary, size: 24.0, strokeWidth: 2.0);
            }

            final user = snapshot.data as User;
            String placeholderImageUrl =
                'https://ui-avatars.com/api/?name=${user.username}';

            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: onPrimary,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl.isNotEmpty
                        ? user.photoUrl
                        : placeholderImageUrl),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 1.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(CupertinoIcons.star_fill,
                                      color: Colors.orange, size: 13.0),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    review.rating.toStringAsFixed(1),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: onBackground,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              formatOnlyDate(review.timeReview),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: onBackground,
                                  ),
                            )
                          ],
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          review.reviewMessage,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: onBackground,
                                  height: 1.35,
                                  fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
