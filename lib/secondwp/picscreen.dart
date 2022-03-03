import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PicScreen extends StatefulWidget {
  const PicScreen({Key? key}) : super(key: key);

  @override
  State<PicScreen> createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> {
  bool? isgranted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: isgranted == true
            ? Text("permission granted")
            : Text("Permission is not granted"),
      ),
    );
  }

  void getpermission() {
    Permission.storage.isGranted.then((value) {
      if (value == true) {
        setState(() {
          isgranted = true;
        });
      } else {
        Permission.storage.request().then((value) {
          setState(() {
            if (value.isGranted) {
              isgranted = true;
            } else {
              getpermission();
            }
          });
        });
      }
    });
  }
}
