import 'package:flutter/material.dart';

class EmptyCollection extends StatelessWidget {
  final String text;
  final IconData icon;

  const EmptyCollection({super.key, required this.text, required this.icon});

  factory EmptyCollection.error(String message) => EmptyCollection(
        text: message,
        icon: Icons.warning_amber_sharp,
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
