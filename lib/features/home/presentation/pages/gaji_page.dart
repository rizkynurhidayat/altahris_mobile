import 'package:flutter/material.dart';

class GajiPage extends StatelessWidget {
  const GajiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaji'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Halaman Gaji sedang dikembangkan'),
      ),
    );
  }
}
