// child: GridView.builder(
                  //   addRepaintBoundaries: true,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       mainAxisSpacing: 10,
                  //       crossAxisSpacing: 10,
                  //       crossAxisCount: 2),
                  //   itemBuilder: (context, index) {
                  //     if (controller!.isCompleted) {
                  //       controller!.reset();
                  //       controller!.forward();
                  //     } else {
                  //       controller!.forward();
                  //     }
                  //     File file = File(imageList[index]);
                  //     return Card(
                  //       elevation: 5.0,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20.0)),
                  //       child: Container(
                  //         width: 100.0,
                  //         height: 100.00,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20.0)),
                  //         child: Stack(
                  //           alignment: Alignment.bottomRight,
                  //           children: [
                  //             Positioned.fill(
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(20.0),
                  //                     image: DecorationImage(
                  //                         image: FileImage(file),
                  //                         fit: BoxFit.cover)),
                  //               ),
                  //             ),
                  //             Container(
                  //               width: 100.0,
                  //               decoration: BoxDecoration(
                  //                   color: Colors.black.withOpacity(0.5),
                  //                   borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(30.0),
                  //                       bottomRight: Radius.circular(20.0))),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   SizedBox(
                  //                     width: 15.0,
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(
                  //                         top: 5.0, bottom: 5.0),
                  //                     child: InkWell(
                  //                       child: Icon(
                  //                         Icons.share,
                  //                         color: Colors.white,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 10.0,
                  //                   ),
                  //                   Visibility(
                  //                     visible: !storedimagelist.contains(
                  //                         imageList[index].split("/").last),
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.only(
                  //                           top: 5.0, bottom: 5.0),
                  //                       child: InkWell(
                  //                         child: Icon(
                  //                           Icons.download,
                  //                           color: Colors.white,
                  //                         ),
                  //                         onTap: () {
                  //                           savefileinstorage(
                  //                                   imageList[index], file)
                  //                               .then((value) {
                  //                             if (value!['isSuccess'] == true) {
                  //                               ScaffoldMessenger.of(context)
                  //                                   .showSnackBar(SnackBar(
                  //                                       content: Text(
                  //                                           "Your File is saved")));
                  //                             }
                  //                           });
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 8.0,
                  //                   )
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   itemCount: imageList.length,
                  // ),
                // );