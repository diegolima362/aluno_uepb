import 'package:flutter/material.dart';

class EmptyCollection extends StatelessWidget {
  final String text;
  final IconData icon;

  const EmptyCollection({Key? key, required this.text, required this.icon})
      : super(key: key);

  factory EmptyCollection.error({String? message}) => EmptyCollection(
        text: message ?? 'Erro ao obter os dados',
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
