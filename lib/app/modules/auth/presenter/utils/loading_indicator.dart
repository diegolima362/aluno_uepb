import 'package:flutter/material.dart';

OverlayEntry get loadingIndicator => OverlayEntry(
      builder: (context) => Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Card(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  'Entrando',
                  style: Theme.of(context).textTheme.button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
