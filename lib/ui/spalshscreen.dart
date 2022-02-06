import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool>? isgranted;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkpermission();
  }

  @override
  Widget build(BuildContext context) {
    final Directory _photoDir = new Directory('/storage/emulated/0/Pictures/');
    // checkpermission();
    return Scaffold(
        body: FutureBuilder(
      future: isgranted,
      builder: (context, snapshot) {
        print("====>${snapshot.data}");

        if (snapshot.data != null) {
          if (snapshot.data == true) {
            var imageList = _photoDir
                .listSync()
                .map((item) => item.path)
                .toList(growable: false);

            print("--->.>>.${imageList}");
            return InkWell(
              onTap: () {
                setState(() {});
              },
              child: Container(
                child: Center(
                  child: Text("data is loading"),
                ),
              ),
            );
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
}
