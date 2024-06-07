import 'package:flutter/material.dart';

import '../data/model/food_post.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodPost post;

  const FoodDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(post.image,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              post.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              post.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text('Category: ${post.category}'),
            Text('Price: \$${post.price}'),
            Text('Posted by: ${post.username}'),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
