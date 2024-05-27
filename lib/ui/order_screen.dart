import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemesanan'),
      ),
      body: Center(
        child: Text(
          'Order Screen',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
