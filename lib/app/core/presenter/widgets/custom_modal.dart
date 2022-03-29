import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final Widget child;
  final double? height;

  const CustomModal({Key? key, required this.child, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        widthFactor: 0,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1080,
            minWidth: 1080,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            height: height ?? MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  child: child,
                  width: double.infinity,
                ),
                Container(
                  color: Colors.transparent,
                  width: 150,
                  height: 24,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor,
                        border: Border.all(color: Colors.transparent),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
