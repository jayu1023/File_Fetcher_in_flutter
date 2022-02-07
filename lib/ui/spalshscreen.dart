import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
    final Directory _second = new Directory('/storage/emulated/0/Pictures/');
    // final Directory _photoDir = new Directory('/storage/emulated/0/Download');
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
              child: GridView.builder(
                addRepaintBoundaries: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  File file = File(imageList[index]);
                  return Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      width: 100.0,
                      height: 100.00,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                      image: FileImage(file),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Container(
                            width: 100.0,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(20.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 15.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
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
                                  visible: !storedimagelist.contains(
                                      imageList[index].split("/").last),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: InkWell(
                                      child: Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        savefileinstorage(
                                                imageList[index], file)
                                            .then((value) {
                                          if (value!['isSuccess'] == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Your File is saved")));
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

  Future<Map?> savefileinstorage(String? path, File img) async {
    // path = path!.replaceAll(img.path.split("/").last, "");
    // print(path);
    final result = await ImageGallerySaver.saveFile(path!.split(".").last,
        name: img.path.split("/").last);
    print(result);
    setState(() {});
    return result;
  }
}
