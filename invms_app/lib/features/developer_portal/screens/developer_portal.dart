import 'package:flutter/material.dart';

class DeveloperPortalScreen extends StatelessWidget {
  const DeveloperPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer Portal')),
      body: const Center(
        child: Text('This is the developer portal.'),
      ),
    );
  }
}