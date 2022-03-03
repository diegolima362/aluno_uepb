import 'package:flutter/material.dart';

class EmptyCollection extends StatelessWidget {
  final String text;
  final IconData icon;

  const EmptyCollection({Key? key, required this.text, required this.icon})
      : super(key: key);

  factory EmptyCollection.error() => const EmptyCollection(
        text: 'Erro ao obter os dados',
        icon: Icons.error_outline_sharp,
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
