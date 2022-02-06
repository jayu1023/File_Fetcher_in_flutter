import 'dart:io';

import 'package:flutter/material.dart';
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
}
