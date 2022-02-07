import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Future<bool>? isgranted;

  AnimationController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    checkpermission();
  }

  @override
  Widget build(BuildContext context) {
    final Directory _photoDir =
        new Directory('/storage/emulated/0/Whatsapp/media/.Statuses');
    final Directory _second = new Directory('/storage/emulated/0/Pictures/');
    // final Directory _photoDir = new Directory('/storage/emulated/0/Download');
    // checkpermission();
    return Scaffold(
        appBar: AppBar(
          title: Text("Images is Here"),
        ),
        body: FutureBuilder(
          future: isgranted,
          builder: (context, snapshot) {
            print("====>${snapshot.data}");

            if (snapshot.data != null) {
              if (snapshot.data == true) {
                var imageList = _photoDir
                    .listSync()
                    .map((item) => item.path)
                    .where((element) => element.endsWith("jpg"))
                    .toList(growable: false);

                var storedimagelist = _second
                    .listSync()
                    .map((e) => e.path.split("/").last)
                    .where((item) => item.endsWith("jpg"))
                    .toList();
                print("--->.>>.${storedimagelist}");
                return Container(
                    margin: EdgeInsets.only(right: 5.0, left: 5.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: LiveGrid.options(
                        itemBuilder: (context, index, animarion) {
                          File file = File(imageList[index]);
                          return FadeTransition(
                              opacity: Tween<double>(
                                begin: 0,
                                end: 1,
                              ).animate(animarion),
                              // And slide transition
                              child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animarion),
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Container(
                                      width: 100.0,
                                      height: 100.00,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  image: DecorationImage(
                                                      image: FileImage(file),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                          Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30.0),
                                                    bottomRight:
                                                        Radius.circular(20.0))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 5.0),
                                                  child: InkWell(
                                                    child: Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Visibility(
                                                  visible: !storedimagelist
                                                      .contains(imageList[index]
                                                          .split("/")
                                                          .last),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 5.0),
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.download,
                                                        color: Colors.white,
                                                      ),
                                                      onTap: () {
                                                        savefileinstorage(
                                                                imageList[
                                                                    index],
                                                                file)
                                                            .then((value) {
                                                          if (value![
                                                                  'isSuccess'] ==
                                                              true) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text("Your File is saved")));
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )));
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: imageList.length,
                        options: LiveOptions(
                            delay: Duration(milliseconds: 200),
                            showItemInterval: Duration(milliseconds: 100),
                            reAnimateOnVisibility: true,
                            showItemDuration: Duration(milliseconds: 100))));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("please give permission it is required"),
                  behavior: SnackBarBehavior.floating,
                ));
                return Container();
              }
            } else {
              return Container(
                child: Center(child: Text('null')),
              );
            }
          },
        ));
  }

  void checkpermission() async {
    if (await Permission.storage.isGranted) {
      isgranted = Permission.storage.isGranted;
    } else {
      await Permission.storage.request();

      isgranted = Permission.storage.isGranted;
    }
    setState(() {});
  }

  Future<Map?> savefileinstorage(String? path, File img) async {
    // path = path!.replaceAll(img.path.split("/").last, "");
    // print(path);

    String name = img.path.split("/").last;
    final result = await ImageGallerySaver.saveFile("${path}",
        name: img.path.split("/").last);
    print(result);
    setState(() {});
    return result;
  }
}
