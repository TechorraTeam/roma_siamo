import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pressfame_new/Screens/createVideoPost.dart';
import 'package:pressfame_new/Screens/filter.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<PhotoScreen> {
  AppState state;
  File imageFile;
  bool selectPhoto = false;
  bool selectVideo = false;
  bool isLoading = false;

  File _video;
  //File _cameraVideo;

  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColorWhite,
        elevation: 0,
        title: Text(
          "New Post",
          style: TextStyle(
              fontSize: 20, color: appColorBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagesWidget()),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: appColorBlack,
            )),
        actions: [
          InkWell(
            onTap: () {
              if (imageFile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FilterScreen(image: imageFile)),
                );
              } else if (_video != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreatVideoePost(video: _video)),
                );

                setState(() {
                  _videoPlayerController.setVolume(0);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Text(
                'Next',
                style: TextStyle(
                    color: appColorBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: <Widget>[
                selectPhoto == true
                    ? Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(bottom: 100, top: 20),
                        child: imageFile != null
                            ? SizedBox(
                                child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              ))
                            : Center(
                                child: Text(
                                  "Select photo or video",
                                  style: TextStyle(
                                    color: appColorBlack,
                                  ),
                                ),
                              ),
                      ))
                    : Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(bottom: 100, top: 20),
                        child: _video != null
                            ? _videoPlayerController.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _videoPlayerController
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController),
                                  )
                                : Center(
                                    child: Text(
                                      "Select photo or video",
                                      style: TextStyle(
                                        color: appColorBlack,
                                      ),
                                    ),
                                  )
                            : Center(
                                child: Text(
                                  "Select photo or video",
                                  style: TextStyle(
                                    color: appColorBlack,
                                  ),
                                ),
                              ),
                      )),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: selectPhoto == true
                              ? Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        selectImageSource();
                                      },
                                      child: Text(
                                        "Photo",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: appColorBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                      child: new Center(
                                        child: new Container(
                                          width: 60,
                                          margin:
                                              new EdgeInsetsDirectional.only(
                                                  start: 1.0, end: 1.0),
                                          height: 3.0,
                                          color: appColorBlack,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectPhoto = true;
                                      selectVideo = false;
                                    });

                                    selectImageSource();
                                  },
                                  child: Text(
                                    "Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: appColorBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins-Medium"),
                                  ))),
                      Expanded(
                        child: selectVideo == true
                            ? Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      selectVideoSource();
                                    },
                                    child: Text(
                                      "Video",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: appColorBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins-Medium"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                    child: new Center(
                                      child: new Container(
                                        width: 60,
                                        margin: new EdgeInsetsDirectional.only(
                                            start: 1.0, end: 1.0),
                                        height: 3.0,
                                        color: appColorBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectPhoto = false;
                                    selectVideo = true;
                                  });

                                  selectVideoSource();
                                },
                                child: Text(
                                  "Video",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: appColorBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins-Medium"),
                                )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          isLoading == true ? Center(child: loader()) : Container()
        ],
      ),
      floatingActionButton: imageFile != null
          ? FloatingActionButton(
              backgroundColor: appColorBlack,
              onPressed: () {
                // if (state == AppState.free)
                //  selectImageSource();
                if (state == AppState.picked)
                  _cropImage();
                else if (state == AppState.cropped) _clearImage();
              },
              child: _buildButtonIcon(),
            )
          : Container(),
    );
  }

  Widget _buildButtonIcon() {
    // if (state == AppState.free)
    //   return Icon(Icons.add);
    if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 40,
      ).then((value) async {
        setState(() {
          imageFile = value;
        });
      });

      setState(() {
        state = AppState.picked;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future getImageFromCamera() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        isLoading = true;
      });
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 30,
      ).then((value) async {
        setState(() {
          isLoading = false;
          imageFile = value;
        });
      });

      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: appColorBlack,
            toolbarWidgetColor: Colors.white,
            statusBarColor: appColorBlack,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  _pickVideo() async {
    var video = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        isLoading = true;
      });
      await VideoCompress.setLogLevel(0);

      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        _video = File(compressedVideo.path);
        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path))
              ..initialize().then((_) {
                setState(() {
                  isLoading = false;
                });
                _videoPlayerController.play();
              });
      } else {}
    }
  }

  _pickVideoFromCamera() async {
    var video = await ImagePicker().getVideo(source: ImageSource.camera);

    if (video != null) {
      await VideoCompress.setLogLevel(0);
      setState(() {
        isLoading = true;
      });
      final compressedVideo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo != null) {
        _video = File(compressedVideo.path);
        _videoPlayerController =
            VideoPlayerController.file(File(compressedVideo.path))
              ..initialize().then((_) {
                setState(() {
                  isLoading = false;
                });
                _videoPlayerController.play();
              });
      } else {}
    }
  }

  // _pickVideoFromCamera() async {
  //   File video = await ImagePicker.pickVideo(source: ImageSource.camera);
  //   _video = video;
  //   _videoPlayerController = VideoPlayerController.file(_video)
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _videoPlayerController.play();
  //     });
  // }

  selectVideoSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 10.0),
              Text(
                "Pick Video",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Poppins-Medium"),
              ),
              Container(height: 30.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _pickVideoFromCamera();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: appColorBlack,
                    ),
                    Container(width: 10.0),
                    Text('Camera',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
              Container(height: 15.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.storage,
                      color: appColorBlack,
                    ),
                    Container(width: 10.0),
                    Text('Gallery',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  selectImageSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 10.0),
              Text(
                "Pick Image",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Poppins-Medium"),
              ),
              Container(height: 30.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  getImageFromCamera();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: appColorBlack,
                    ),
                    Container(width: 10.0),
                    Text('Camera',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
              Container(height: 15.0),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  getImageFromGallery();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.storage,
                      color: appColorBlack,
                    ),
                    Container(width: 10.0),
                    Text('Gallery',
                        style: TextStyle(fontFamily: "Poppins-Medium"))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// import 'dart:collection';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'dart:io';
// import 'dart:async';
// import 'package:image_gallery/image_gallery.dart';

// class PhotoScreem extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<PhotoScreem> {
//   Map<dynamic, dynamic> allImageInfo = new HashMap();
//   List allImage = new List();
//   List allNameList = new List();
//   var orientation;
//   var dataImage ;
//    var thumbnail;

//   @override
//   void initState() {
//     super.initState();
//     loadImageList();
//   }

//   Future<void> loadImageList() async {
//     Map<dynamic, dynamic> allImageTemp;
//     allImageTemp = await FlutterGallaryPlugin.getAllImages;
//     print(" call $allImageTemp.length");

//     setState(() {
//       this.allImage = allImageTemp['URIList'] as List;
//       this.allNameList = allImageTemp['DISPLAY_NAME'] as List;

//     //  dataImage = img.decodeImage(File(allImageTemp['URIList']).readAsBytesSync());

//     //  thumbnail = img.copyResize(dataImage,width: 120);

//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: const Text('Image Gallery'),
//         ),
//         body: Column(
//           children: <Widget>[
//             // Expanded(child: Image.file(File(allImage[0].toString()))),
//             Expanded(child: _buildGrid()),
//           ],
//         ),
//       ),
//     );
//   }

//     Widget _buildGrid() {

//     if (allImage.length > 0) {
//       return GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         primary: false,
//         padding: EdgeInsets.all(5),
//         //itemCount: allImage.length,
//         itemCount: 20,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           childAspectRatio: 200 / 200,
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: EdgeInsets.all(5.0),
//             child: GestureDetector(
//               onTap: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //       builder: (context) =>
//                 //           ViewPost(id: _orderList[index].key)),
//                 // );
//               },
//               child: Container(
//                 height: 60,
//                 width: 60,
//                 child:  allImage[index] != null &&  allImage[index].length>0
//                         ? Image.file(File(allImage[index].toString())):
//                          Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Icon(
//                               Icons.person,
//                               size: 25,
//                             ),
//                           ),
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       return Center(
//         child: Padding(
//            padding: const EdgeInsets.only(bottom:200),
//           child: Text(
//             "Post list is empty",
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//       );
//     }
//   }

// }
