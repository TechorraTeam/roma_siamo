import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class CreatePost extends StatefulWidget {
  File image;
  CreatePost({this.image});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<CreatePost> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentLocation;
  String _currentAddress;
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
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

        Placemark place = p.first;

        setState(() {
          _currentAddress = "${place.name}, ${place.locality}";
          //"${place.name}, ${place.locality},${place.administrativeArea},${place.country}";
          locationController.text = _currentAddress.toString();
          print(_currentAddress);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorWhite,
          elevation: 0,
          title: Text(
            "new_post".tr,
            style: TextStyle(
                fontSize: 20,
                color: appColorBlack,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: appColorBlack,
              )),
          actions: [
            InkWell(
              onTap: () {
                addPost(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Text(
                  'done'.tr,
                  style: TextStyle(
                      color: appColorBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 20,
                  ),
                  widget.image == null
                      ? GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/ic_add.png'),
                              backgroundColor: Colors.transparent),
                        )
                      : Container(
                          height: 200,
                          width: 200,
                          child: Image.file(widget.image)),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                          hintStyle:
                              new TextStyle(color: Colors.white, fontSize: 12),
                          hintText: "write_something_add_hashtag".tr,
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
                      padding:
                          const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                          hintStyle:
                              new TextStyle(color: Colors.white, fontSize: 12),
                          hintText: "type_location_where_taken".tr,
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
                ],
              ),
              isLoading == true ? Center(child: loader()) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  addPost(BuildContext context) async {
    if (widget.image != null) {
      setState(() {
        isLoading = true;
      });

      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${Timestamp.now().microsecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        widget.image.absolute.path,
        targetPath,
        quality: 30,
      ).then((value) async {
        print("Compressed");
        UploadTask task = await uploadFile2(value);

        TaskSnapshot storageTaskSnapshot = await task;

        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          var time = Timestamp.now().microsecondsSinceEpoch.toString();

          FirebaseFirestore.instance.collection("post").doc(time).set({
            'idFrom': globalID,
            'userName': globalName,
            'userImage': globalImage,
            'timestamp': time,
            'content': downloadUrl,
            'caption': descriptionController.text ?? "",
            'location': locationController.text ?? "",
            'latitude': currentLocation.latitude,
            'longitude': currentLocation.longitude,
            'geoPoint': GeoPoint(currentLocation.latitude, currentLocation.longitude),
            'likes': [],
            'comments': [],
            'videoUrl': '',
          }).then((value) {
            setState(() {
              isLoading = false;
            });

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PagesWidget()),
            );
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
