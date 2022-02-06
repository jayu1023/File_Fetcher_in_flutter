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
    final Directory _photoDir =
        new Directory('/storage/emulated/0/Whatsapp/media/.Statuses');
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
                .where((element) => element.endsWith("jpg"))
                .toList(growable: false);

            print("--->.>>.${imageList}");
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                addRepaintBoundaries: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  File file = File(imageList[index]);
                  return InkWell(
                    onTap: () {
                      File img = new File(imageList[index]);

                      savefileinstorage(imageList[index], img).then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("file is saved on ${value!}"))));
                      // setState(() {});
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.00,
                      child: Image.file(
                        file,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                itemCount: imageList.length,
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

  Future<String?> savefileinstorage(String? path, File img) async {
    Directory _appDocDirFolder = Directory('/storage/emulated/0/.Mystatus/');

    var dt = DateTime.now();
    if (await _appDocDirFolder.exists()) {
      File file = new File(path!);

      checkpermission();
      // print(file.copySync("${_appDocDirFolder.path}image3.jpg"));
      return file
          .copySync(
              "/storage/emulated/0/image${dt.microsecond}${dt.timeZoneOffset.toString().substring(2, 5)}.jpg")
          .path;
    } else {
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      _appDocDirNewFolder.path;

      File file = new File(path!);

      checkpermission();
      // print(file.copySync("${_appDocDirFolder.path}image3.jpg"));
      return file
          .copySync(
              "/storage/emulated/0/image${dt.microsecond}${dt.timeZoneOffset.toString().substring(2, 5)}.jpg")
          .path;
    }
  }
}
