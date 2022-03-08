import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PicScreen extends StatefulWidget {
  const PicScreen({Key? key}) : super(key: key);

  @override
  State<PicScreen> createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> {
  bool? isgranted = false;
  bool? iswpinstall = false;
  List<dynamic>? imagelist = [];
  Directory picdir =
      new Directory('/storage/emulated/0/Whatsapp/media/.Statuses');

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
            ? Center(
                child: iswpinstall != true
                    ? Text("install wp")
                    : imagelist!.length == 0
                        ? Text("No Data")
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.8, crossAxisCount: 2),
                            itemCount: imagelist!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100.0,
                                height: 100.0,
                                color: Colors.grey,
                                margin: EdgeInsets.all(8.0),
                                child: Image.file(File(imagelist![index])),
                              );
                            }))
            : Center(child: Text("Permission is not granted")),
      ),
    );
  }

  void getpermission() {
    Permission.storage.isGranted.then((value) {
      if (value == true) {
        getdata();
        setState(() {
          isgranted = true;
        });
      } else {
        Permission.storage.request().then((value) {
          setState(() {
            if (value.isGranted) {
              isgranted = true;
              getdata();
              setState(() {});
            } else {
              getpermission();
            }
          });
        });
      }
    });
  }

  void getdata() {
    try {
      picdir.exists().then((value) async {
        print("bjdbf");
        print(value);
        iswpinstall = true;
        print("dgcytfudyfe");

        imagelist = picdir
            .listSync(recursive: true)
            .map((item) => item.path)
            .where((element) => element.endsWith("jpg"))
            .toList(growable: false);

        setState(() {
          print(imagelist);
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
