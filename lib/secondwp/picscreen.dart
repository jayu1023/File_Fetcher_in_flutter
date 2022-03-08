import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsappstatusdownloader/secondwp/photoview.dart';

class PicScreen extends StatefulWidget {
  const PicScreen({Key? key}) : super(key: key);

  @override
  State<PicScreen> createState() => _PicScreenState();
}

class _PicScreenState extends State<PicScreen> {
  bool? isgranted = false;
  bool? iswpinstall = false;
  List<dynamic>? imagelist = [];
  List<dynamic>? storedImageList = [];
  Directory storDir = new Directory('/storage/emulated/0/Pictures/');
  Directory picDir =
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
                        : LiveGrid.options(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.8, crossAxisCount: 2),
                            itemCount: imagelist!.length,
                            itemBuilder: (context, index, animarion) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return PhotoView(
                                      imagepath: imagelist![index],
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      // margin: EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 100.0,
                                        width: 100.0,
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Positioned.fill(
                                                child: Image.file(
                                                    File(imagelist![index]),
                                                    height: 100.0,
                                                    width: 100.0,
                                                    fit: BoxFit.cover)),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2.0, top: 2.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  30 /
                                                  100,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30.0))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                      child: Icon(
                                                    Icons.download,
                                                    color: Colors.white,
                                                  )),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            5 /
                                                            100,
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: LiveOptions(
                                delay: Duration(milliseconds: 200),
                                showItemInterval: Duration(milliseconds: 100),
                                reAnimateOnVisibility: true,
                                showItemDuration: Duration(milliseconds: 100))),
              )
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
      picDir.exists().then((value) async {
        print("bjdbf");
        print(value);
        iswpinstall = true;
        print("dgcytfudyfe");

        imagelist = picDir
            .listSync(recursive: true)
            .map((item) => item.path)
            .where((element) => element.endsWith("jpg"))
            .toList(growable: false);
        storedImageList = storDir
            .listSync(recursive: true)
            .map((e) => e.path)
            .where((element) => element.endsWith("jpg"))
            .toList(growable: false);
        setState(() {
          print(imagelist);
          print(storedImageList);
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
