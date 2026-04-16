import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: const Center(
        child: Text(
          'Halaman ini masih dalam pengembangan!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}