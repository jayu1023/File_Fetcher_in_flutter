import 'package:flutter/material.dart';
import 'package:whatsappstatusdownloader/ui/spalshscreen.dart';
import 'package:whatsappstatusdownloader/ui/videoscreen.dart';

class DashBoardscreen extends StatefulWidget {
  DashBoardscreen({Key? key}) : super(key: key);

  @override
  State<DashBoardscreen> createState() => _DashBoardscreenState();
}

class _DashBoardscreenState extends State<DashBoardscreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //       appBar: AppBar(
    //         bottom: PreferredSize(
    //           preferredSize: Size(MediaQuery.of(context).size.width, 100.0),
    //           child: TabBar(tabs: [
    //             Tab(
    //               text: "videos",
    //               icon: Icon(Icons.video_settings),
    //             ),
    //             Tab(
    //               text: "videos",
    //               icon: Icon(Icons.video_settings),
    //             ),
    //           ]),
    //         ),
    //       ),
    //       body: TabBarView(
    //         children: [SplashScreen(), VideoScreen()],
    //       )),
    // );
  }
}
