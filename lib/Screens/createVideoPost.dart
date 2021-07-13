import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class CreatVideoePost extends StatefulWidget {
  File video;

  CreatVideoePost({this.video});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<CreatVideoePost> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentLocation;
  String _currentAddress;
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  bool isLoading = false;
  String currentUserName;
  String currentUserImage;

  //File _video;
  //File _cameraVideo;

  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _getAddressFromLatLng();


    _pickVideo();
    super.initState();
  }

  _pickVideo() async {
    // File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    //  widget.video = video;
    _videoPlayerController = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.pause();
      });
  }


  Future getUserCurrentLocation() async {
    await Geolocator().getCurrentPosition().then((position) {
      setState(() {
        currentLocation = position;
      });
    });
  }

  _getAddressFromLatLng() async {
    getUserCurrentLocation().then((_) async {
      try {
        List<Placemark> p = await geolocator.placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude);

        Placemark place = p[0];

        setState(() {
          _currentAddress = "${place.name}, ${place.locality}";
          //"${place.name}, ${place.locality},${place.administrativeArea},${place.country}";
          print(_currentAddress);
          locationController.text = _currentAddress.toString();
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 80),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.transparent,
                        spreadRadius: 5,
                        blurRadius: 2)
                  ]),
                  width: MediaQuery.of(context).size.width,
                  height: SizeConfig.blockSizeVertical * 20,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [appColorBlack, appColorBlack]),
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Text(
                              "New Post",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Medium",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          addPost(context);
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                        ),

                        Container(
                          height: 200,
                          child: widget.video != null
                              ? _videoPlayerController.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    )
                                  : Container(child: Text("Null"))
                              : GestureDetector(
                                  onTap: () {
                                    _pickVideo();
                                  },
                                  child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                          'assets/images/ic_add.png'),
                                      backgroundColor: Colors.transparent),
                                ),
                        ),

                        Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 20, left: 20),
                            child: TextField(
                              controller: descriptionController,
                              style: TextStyle(color: Colors.white),
                              maxLines: 3,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: Colors.white, fontSize: 12),
                                hintText: "write something about post or add # tags",
                                fillColor: appColorGrey,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: appColorGrey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: appColorGrey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )),

                        Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 20, left: 20),
                            child: TextField(
                              controller: locationController,
                              style: TextStyle(color: Colors.white),
                              maxLines: 1,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: Colors.white, fontSize: 12),
                                hintText: "Type location where it was taken",
                                fillColor: appColorGrey,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: appColorGrey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: appColorGrey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )),

                        //      GestureDetector(
                        //   onTap: () {
                        //     _getAddressFromLatLng();
                        //   },
                        //   child: Padding(
                        //     padding:
                        //         const EdgeInsets.only(top: 20, right: 20, left: 20),
                        //     child: Container(
                        //       height: 50,
                        //       width: double.infinity,
                        //       decoration: new BoxDecoration(
                        //           color: appColorGrey,
                        //           borderRadius:
                        //               new BorderRadius.all(Radius.circular(10.0))),
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(left: 15, top: 17),
                        //         child: Text(
                        //           _currentAddress != null
                        //               ? _currentAddress
                        //               : "Get location where it was taken",
                        //           overflow: TextOverflow.ellipsis,
                        //           style: TextStyle(color: Colors.white, fontSize: 12),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),//  Expanded(child: _serachuser()),
                      ],
                    ),
                    isLoading == true ? Center(child: loader()) : Container(),
                  ],
                ),
              );
            },
          )),
    );
  }

  addPost(BuildContext context) async {
    if (widget.video != null) {
      setState(() {
        isLoading = true;
      });

      var timeKey = new DateTime.now();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('videoPost')
          .child('/$timeKey.mp4');

      final metadata = SettableMetadata(
          contentType: 'video/mp4',
          customMetadata: {'picked-file-path': widget.video.path});

      UploadTask uploadTask = ref.putFile(File(widget.video.path), metadata);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
        await VideoThumbnail.thumbnailFile(
          video: downloadUrl,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          quality: 100,
        ).then((thumbnail) async {
          UploadTask task = await uploadFile2(File(thumbnail));

          TaskSnapshot storageTaskSnapshot = await task;

          storageTaskSnapshot.ref.getDownloadURL().then((finalThumbnail) {
            var time = DateTime.now().millisecondsSinceEpoch.toString();

            FirebaseFirestore.instance.collection("post").doc(time).set({
              'idFrom': globalID,
              'userName': globalName,
              'userImage': globalImage,
              'timestamp': time,
              'content': downloadUrl,
              'caption': descriptionController.text ?? "",
              'location': locationController.text ?? "",
              'likes': [],
              'comments': [],
              'videoUrl': finalThumbnail,
            }).then((value) {
              setState(() {
                isLoading = false;
              });
              _videoPlayerController.dispose();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagesWidget()),
              );
            });
          });
        });
      }, onError: (err) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });

      toast("Error", "Field is empty or Select Image", context);


    }
  }

}
