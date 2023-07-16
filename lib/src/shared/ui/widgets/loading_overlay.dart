import 'package:flutter/material.dart';

OverlayEntry get loadingOverlay => OverlayEntry(
      builder: (context) => Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  'Entrando',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
