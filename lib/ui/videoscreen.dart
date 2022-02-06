import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Future<bool>? isgranted;
  final Directory path_dir =
      new Directory('/storage/emulated/0/Whatsapp/media/.Statuses');

  void checkpermission() async {
    if (await Permission.storage.isGranted) {
      isgranted = Permission.storage.isGranted;
    } else {
      await Permission.storage.request();
      isgranted = Permission.storage.isGranted;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkpermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: isgranted,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data == true) {
              var imagelist = path_dir
                  .listSync(recursive: true, followLinks: false)
                  .map((e) => e.path)
                  .where((element) => element.endsWith("mp4"))
                  .toList(growable: false);
              return (Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      File file =
                          new File(getthumbnail(imagelist[index]).toString());
                      return Container(
                          width: 100.0,
                          height: 100.0,
                          child: FutureBuilder(
                            future: getthumbnail(imagelist[index]),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Image.file(
                                    snapshot.data,
                                    fit: BoxFit.covers,
                                  ),
                                );
                              } else {
                                return Container(
                                  child: Text("No videos here"),
                                );
                              }
                            },
                          ));
                    }),
              ));
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
      ),
    );
  }

  Future<String> getthumbnail(String videoPath) async {
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder:
            ' /storage/emulated/0/Whatsapp/media', // creates the specified path if it doesnt exist
        videoFile: videoPath,
        imageType: ThumbFormat.PNG,
        quality: 30);

    return thumb;
  }

  /*
    * thumbnailFolder property can be omitted if you dont wish to keep the generated thumbails past each usage
    */
}
