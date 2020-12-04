import 'dart:io';

import 'package:flutter/material.dart';

class ExtendedImage extends StatelessWidget {
  final File image;

  const ExtendedImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Extended Image"),
      ),
      body: Hero(
          tag: image,
          child: Image.file(image,
              height: double.infinity, width: double.infinity)),
    );
  }
}
