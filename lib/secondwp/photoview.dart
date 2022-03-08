import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:whatsappstatusdownloader/secondwp/customloader.dart';
import 'package:whatsappstatusdownloader/secondwp/picscreen.dart';

class PhotoView extends StatefulWidget {
  final String? imagepath;
  const PhotoView({Key? key, this.imagepath}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 8.0, bottom: 8.0, top: 8.0),
                child: Image.file(
                  File(widget.imagepath.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RawMaterialButton(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fillColor: Colors.greenAccent,
                onPressed: () {
                  CustomLoader().showLoader();
                  try {
                    ImageGallerySaver.saveFile(widget.imagepath.toString())
                        .then((value) {
                      CustomLoader().successLoader("Saved Succesfully");
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PicScreen()));
                    });
                  } catch (e) {
                    CustomLoader().ErrorLoader(e.toString());
                  } finally {
                    CustomLoader().dismisLoader();
                  }
                },
                child: Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 25.0,
                ),
                elevation: 20.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
