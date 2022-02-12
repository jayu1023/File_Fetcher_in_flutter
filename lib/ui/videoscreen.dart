import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoScreen extends StatefulWidget {
  Future<bool>? isgranted;
  VideoScreen({Key? key, this.isgranted}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final Directory path_dir =
      new Directory('/storage/emulated/0/Whatsapp/media/.Statuses');
  final Directory stored_dir = new Directory('/storage/emulated/0/Pictures/');

  void checkpermission() async {
    if (await Permission.storage.isGranted) {
      widget.isgranted = Permission.storage.isGranted;
    } else {
      await Permission.storage.request();
      widget.isgranted = Permission.storage.isGranted;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkpermission();
    print("${widget.isgranted}");
    //fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.isgranted,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            print("==......>${snapshot.data}");
            if (snapshot.data == true) {
              var imagelist = path_dir
                  .listSync(recursive: false, followLinks: false)
                  .map((e) => e.path)
                  .where((element) => element.endsWith("mp4"))
                  .toList();

              var storedvdlist = stored_dir
                  .listSync(
                    recursive: false,
                  )
                  .map((e) => e.path.split("/").last)
                  .where((element) => element.endsWith("mp4"))
                  .toList();

              print("====>>>>${imagelist}");
              return (Container(
                margin: EdgeInsets.only(right: 5.0, left: 5.0, top: 2.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: LiveGrid.options(
                    shrinkWrap: true,
                    itemBuilder: (context, index, animation) {
                      return FadeTransition(
                          opacity: Tween<double>(
                            begin: 0,
                            end: 1,
                          ).animate(animation),
                          // And slide transition
                          child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, -0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    child: FutureBuilder(
                                      future: getthumbnail(imagelist[index]),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            File vidthumbfile =
                                                new File(snapshot.data);
                                            return Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Positioned.fill(
                                                  child: Container(
                                                    width: 100.0,
                                                    height: 100.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                vidthumbfile),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100.0,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      20.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      20.0))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        width: 15.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                        visible: !storedvdlist
                                                            .contains(
                                                                imagelist[index]
                                                                    .split("/")
                                                                    .last),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0,
                                                                  bottom: 5.0),
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons.download,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onTap: () {
                                                              savevideoonstorage(
                                                                      imagelist[
                                                                          index])
                                                                  .then(
                                                                      (value) {
                                                                if (value![
                                                                        'isSuccess'] ==
                                                                    true) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(SnackBar(
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
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Container(
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                      },
                                    )),
                              )));
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    itemCount: imagelist.length,
                    options: LiveOptions(
                        delay: Duration(milliseconds: 200),
                        showItemInterval: Duration(milliseconds: 100),
                        reAnimateOnVisibility: true,
                        showItemDuration: Duration(milliseconds: 100))),

                // child: GridView.builder(
                //     itemCount: imagelist.length,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         crossAxisSpacing: 10.0,
                //         mainAxisSpacing: 10.0),
                //     itemBuilder: (context, index) {
                // return Card(
                //   elevation: 10.0,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20.0)),
                //   child: Container(
                //       width: 100.0,
                //       height: 100.0,
                //       child: FutureBuilder(
                //         future: getthumbnail(imagelist[index]),
                //         builder: (BuildContext context,
                //             AsyncSnapshot<dynamic> snapshot) {
                //           if (snapshot.hasData) {
                //             File vidthumbfile = new File(snapshot.data);
                //             return Container(
                //               width: 100.0,
                //               height: 100.0,
                //               decoration: BoxDecoration(
                //                   borderRadius:
                //                       BorderRadius.circular(20.0),
                //                   image: DecorationImage(
                //                       image: FileImage(vidthumbfile),
                //                       fit: BoxFit.cover)),
                //             );
                //           } else {
                //             return Container();
                //           }
                //         },
                //       )),
                // );
                //     }),
              ));
            } else {
              return Container(
                child: Text("null"),
              );
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> getthumbnail(String videoPath) async {
    String thumb = await Thumbnails.getThumbnail(
        // creates the specified path if it doesnt exist
        videoFile: videoPath,
        imageType: ThumbFormat.PNG,
        quality: 30);

    return thumb;
  }

  Future<Map?> savevideoonstorage(String? path) async {
    final result = await ImageGallerySaver.saveFile(path!.split(".").last,
        name: path.split("/").last);
    print("==>!!!!!!!${result}");
    setState(() {});
    return result;
  }

  Future<void> fetchdata() async {
    //simpleTask will be emitted here.
  }
}
