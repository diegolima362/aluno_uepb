import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomAlert<T> extends HookWidget {
  final String title;
  final Widget Function(void Function(T?), T? value) contentBuilder;
  final T? initialValue;
  final void Function(T? value) onValueChanged;

  const CustomAlert({
    Key? key,
    required this.title,
    required this.contentBuilder,
    required this.initialValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = useState(initialValue);

    return AlertDialog(
      title: Text(title),
      content: contentBuilder(
        (val) => state.value = val,
        state.value,
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            onValueChanged(state.value);
          },
        ),
      ],
    );
  }
}
