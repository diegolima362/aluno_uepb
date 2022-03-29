import 'package:flutter/material.dart';

class FilledButton extends ElevatedButton {
  FilledButton(
    BuildContext context, {
    Key? key,
    required VoidCallback? onPressed,
    required Widget? child,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith((states) => 0),
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) => onPressed != null
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            ),
            foregroundColor: MaterialStateProperty.resolveWith(
              (states) => onPressed != null
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
            ),
            textStyle: MaterialStateProperty.resolveWith(
                (_) => Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: onPressed != null
                          ? Theme.of(context).colorScheme.onSecondaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.38),
                    )),
            shape: MaterialStateProperty.resolveWith(
              (_) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            fixedSize: MaterialStateProperty.resolveWith(
              (_) => const Size(double.infinity, 40),
            ),
            minimumSize: MaterialStateProperty.resolveWith(
              (_) => const Size(48, 40),
            ),
          ),
        );
}
