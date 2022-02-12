import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';

final Directory _videoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class VideoScreen2 extends StatefulWidget {
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_videoDir.path}').existsSync()) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Install WhatsApp\n',
              style: TextStyle(fontSize: 18.0),
            ),
            const Text(
              "Your Friend's Status Will Be Available Here",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(body: VideoGrid(directory: _videoDir));
    }
  }
}

class VideoGrid extends StatefulWidget {
  final Directory directory;

  const VideoGrid({required this.directory});

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  Future<String> _getImage(videoPathUrl) async {
    //await Future.delayed(Duration(milliseconds: 500));
    final thumb = await Thumbnails.getThumbnail(
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 10);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    final videoList = widget.directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith('.mp4'))
        .toList(growable: false);

    if (videoList != null) {
      if (videoList.length > 0) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: GridView.builder(
            itemCount: videoList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.0,
              mainAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                        colors: [
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                        ],
                      ),
                    ),
                    child: FutureBuilder(
                        future: _getImage(videoList[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Hero(
                                tag: videoList[index],
                                child: Image.file(
                                  File(snapshot.data.toString()),
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          } else {
                            return Hero(
                              tag: videoList[index],
                              child: SizedBox(
                                height: 280.0,
                                child: Image.asset(
                                    'assets/images/video_loader.gif'),
                              ),
                            );
                          }
                        }),
                    //new cod
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text(
            'Sorry, No Videos Found.',
            style: TextStyle(fontSize: 18.0),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
