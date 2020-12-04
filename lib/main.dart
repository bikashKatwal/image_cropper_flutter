import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  final picker = ImagePicker();

  getImageFile({ImageSource imageSource}) async {
    final pickedFile = await picker.getImage(source: imageSource);
    File _croppedFile = await _cropImage(imageFile: pickedFile);
    //Error - need more research
    // var _compressedImage = await FlutterImageCompress.compressAndGetFile(
    //     _croppedFile.path, _croppedFile.path,
    //     quality: 88);
    setState(() {
      if (_croppedFile != null) _image = _croppedFile;
    });
  }

  Future<File> _cropImage({PickedFile imageFile}) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          // CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0));
    return croppedFile;
    // File croppedFile = await ImageCropper.cropImage(
    //     sourcePath: imageFile.path,
    //     aspectRatioPresets: [
    //       CropAspectRatioPreset.square,
    //       CropAspectRatioPreset.ratio3x2,
    //       CropAspectRatioPreset.original,
    //       CropAspectRatioPreset.ratio4x3,
    //       CropAspectRatioPreset.ratio16x9
    //     ],
    //       androidUiSettings: AndroidUiSettings(
    //           toolbarTitle: 'Cropper',
    //           toolbarColor: Colors.deepOrange,
    //           toolbarWidgetColor: Colors.white,
    //           initAspectRatio: CropAspectRatioPreset.original,
    //           lockAspectRatio: false),
    //       iosUiSettings: IOSUiSettings(
    //         minimumAspectRatio: 1.0,
    //       ));
  }

  @override
  Widget build(BuildContext context) {
    print("IMAGE SIZE ${_image.lengthSync()}");

    return Scaffold(
      appBar: AppBar(
        title: Text("Click | Pick | Crop | Compress"),
      ),
      body: Center(
        child: _image == null
            ? Text("Image")
            : Image.file(_image, height: 200, width: 200),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => getImageFile(imageSource: ImageSource.camera),
            label: Text("Camera"),
            heroTag: UniqueKey(),
            icon: Icon(Icons.add_a_photo),
          ),
          SizedBox(width: 20),
          FloatingActionButton.extended(
            onPressed: () => getImageFile(imageSource: ImageSource.gallery),
            label: Text("Gallery"),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
