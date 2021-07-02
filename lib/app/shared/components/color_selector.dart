import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final List<Color> colors;
  final Color selectedColor;
  final void Function(Color color)? onTap;

  const ColorPicker({
    Key? key,
    required this.colors,
    required this.selectedColor,
    this.onTap,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.selectedColor;
    selectedIndex = widget.colors.indexOf(
        widget.colors.firstWhere((Color e) => e.value == selectedColor.value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemCount: widget.colors.length,
        itemBuilder: (BuildContext ctx, index) {
          return GestureDetector(
            onTap: () => selectColor(index),
            child: Container(
              child: index == selectedIndex
                  ? Icon(Icons.check, color: Theme.of(context).cardColor)
                  : null,
              margin: const EdgeInsets.all(2),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: widget.colors[index],
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          );
        },
      ),
    );
  }

  void selectColor(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (widget.onTap != null) {
      widget.onTap!(widget.colors[index]);
    }
  }
}
