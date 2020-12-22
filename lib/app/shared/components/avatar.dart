import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.image, @required this.radius}) : super(key: key);

  final Image image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: image != null ? image.image : null,
        child: image == null ? Icon(Icons.camera_alt, size: radius) : null,
      ),
    );
  }
}
