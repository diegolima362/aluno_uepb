import 'package:flutter/material.dart';

import 'custom_modal.dart';

class OptionsModal<T> extends StatelessWidget {
  const OptionsModal({
    Key? key,
    required this.items,
    required this.onSelected,
    required this.itemBuilder,
    this.title = '',
  }) : super(key: key);

  final List<T> items;
  final void Function(T) onSelected;
  final Widget Function(T) itemBuilder;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          const Divider(height: 0, thickness: 0.5),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: items
                    .map((e) => GestureDetector(
                          child: itemBuilder(e),
                          onTap: () {
                            onSelected(e);
                            Navigator.of(context).pop();
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
