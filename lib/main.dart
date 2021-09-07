import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_drawer_flutter/lib/painter.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Drawer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile = File('');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(50, 50),
        child: AppBar(
          backgroundColor: Colors.blue,
          actions: [Icon(Icons.ac_unit)],
        ),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            var imagePicker = ImagePicker();
            final filePicked = await imagePicker.pickImage(source: ImageSource.gallery);

            setState(() {
              _imageFile = File(filePicked!.path);
            });
            openImageEdit();
          },
          child: Text("Open Editor"),
        ),
      ),
    );
  }

  Future<void> openImageEdit() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Painter(
        imageFile: _imageFile,
        onBackTap: () => Navigator.pop(context),
        isShowLoading: true,
        calBackImage: (imageEdited) => Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(imageEdited),
          ),
        ),
      );
    }));
  }
}
