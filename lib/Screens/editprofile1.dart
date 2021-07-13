import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pressfame_new/Screens/personalinfo.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  File _image;
  Future<void> getImage() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image.path);
      print('Image Path $_image');
    });
  }

  @override
  void initState() {
    nameController.text = globalName;
    webController.text = globalWeb;
    bioController.text = globalBio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorWhite,
          elevation: 1,
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontSize: 16,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (_image != null &&
                      nameController.text.isNotEmpty &&
                      webController.text.isNotEmpty &&
                      bioController.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });

                    final dir = await getTemporaryDirectory();
                    final targetPath = dir.absolute.path +
                        "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

                    await FlutterImageCompress.compressAndGetFile(
                      _image.absolute.path,
                      targetPath,
                      quality: 20,
                    ).then((value) async {
                      print("Compressed");
                      UploadTask task = await uploadFile2(value);

                      TaskSnapshot storageTaskSnapshot = await task;

                      storageTaskSnapshot.ref.getDownloadURL().then(
                          (downloadUrl) {
                        FirebaseFirestore.instance
                            .collection("user")
                            .doc(globalID)
                            .update({
                          'img': downloadUrl,
                          'name': nameController.text,
                          'website': webController.text,
                          'bio': bioController.text
                        }).then((value) {
                          setState(() {
                            globalName = nameController.text;
                            globalWeb = webController.text;
                            globalBio = bioController.text;
                            globalImage = downloadUrl;
                            isLoading = false;
                          });
                          toast("Success", "Profile Updated Sucesssfully",
                              context);
                        });
                      }, onError: (err) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    });
                  } else if (nameController.text.isNotEmpty &&
                      webController.text.isNotEmpty &&
                      bioController.text.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(globalID)
                        .update({
                      'name': nameController.text,
                      'website': webController.text,
                      'bio': bioController.text
                    }).then((value) {
                      setState(() {
                        globalName = nameController.text;
                        globalWeb = webController.text;
                        globalBio = bioController.text;
                      });
                      toast("Success", "Profile Updated Sucesssfully", context);
                    });
                  } else {
                    toast("Error", "Missing Fields", context);
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(width: 20)
          ],
        ),
        body: Stack(
          children: <Widget>[
            _userInfo2(),
            isLoading == true
                ? Center(
                    child: loader(),
                  )
                : Container()
          ],
        ));
  }

  Widget _userInfo2() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(
                          color:
                              appColorBlack, //                   <--- border color
                          width: 3.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: CircleAvatar(
                            backgroundImage: _image != null
                                ? FileImage(_image)
                                : globalImage.length > 0
                                    ? NetworkImage(globalImage)
                                    : NetworkImage(
                                        "${"https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png"}"),
                            radius: 50,
                          ),
                        ),
                      ),
                    ),
                    Container(height: 5),
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Text(
                        "Change profile photo",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                Container(height: 20),
                divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              color: appColorBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Enter Name",
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 14),
                              alignLabelWithHint: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 0.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 0.5),
                              ),
                            ),
                            // scrollPadding: EdgeInsets.all(20.0),
                            // keyboardType: TextInputType.multiline,
                            // maxLines: 99999,
                            style:
                                TextStyle(color: appColorBlack, fontSize: 15),
                            autofocus: false,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          "Website",
                          style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              color: appColorBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextField(
                            controller: webController,
                            decoration: InputDecoration(
                              hintText: "Enter Website",
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 14),
                              alignLabelWithHint: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 0.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 0.5),
                              ),
                            ),
                            // scrollPadding: EdgeInsets.all(20.0),
                            // keyboardType: TextInputType.multiline,
                            // maxLines: 99999,
                            style:
                                TextStyle(color: appColorBlack, fontSize: 15),
                            autofocus: false,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Bio",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                color: appColorBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextField(
                            controller: bioController,
                            decoration: InputDecoration(
                              hintText: "Enter Bio",
                              hintStyle: TextStyle(
                                  color: Colors.grey[500], fontSize: 14),
                              alignLabelWithHint: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 0.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 0.5),
                              ),
                            ),
                            scrollPadding: EdgeInsets.all(20.0),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style:
                                TextStyle(color: appColorBlack, fontSize: 15),
                            autofocus: false,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PersonalInfo()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Personal information Settings',
                          style: TextStyle(color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(height: 10),
                divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 0.5,
      color: Colors.grey[400],
    );
  }

  // Widget _userInfo() {
  //   return SingleChildScrollView(
  //     padding: EdgeInsets.symmetric(horizontal: 0),
  //     child: Stack(
  //       children: <Widget>[
  //         Container(
  //           width: MediaQuery.of(context).size.width,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               SizedBox(height: 40),
  //               Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(100.0),
  //                   border: Border.all(
  //                     color:
  //                         appColorBlack, //                   <--- border color
  //                     width: 3.0,
  //                   ),
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(3),
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       getImage();
  //                     },
  //                     child: CircleAvatar(
  //                       backgroundImage: _image != null
  //                           ? FileImage(_image)
  //                           : globalImage.length > 0
  //                               ? NetworkImage(globalImage)
  //                               : NetworkImage(
  //                                   "${"https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png"}"),
  //                       radius: 50,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
  //                 child: Container(
  //                   color: Colors.white,
  //                   child: Column(
  //                     children: <Widget>[
  //                       GestureDetector(
  //                         child: Material(
  //                           elevation: 5.0,
  //                           shadowColor: Colors.white,
  //                           borderRadius: BorderRadius.circular(10.0),
  //                           child: Container(
  //                             width: SizeConfig.screenWidth,
  //                             decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius: BorderRadius.circular(10.0),
  //                                 border: Border.all(
  //                                     color: appColorBlack, width: 1.5)),
  //                             child: Padding(
  //                               padding: EdgeInsets.only(
  //                                 top: 10.0,
  //                                 bottom: 00.0,
  //                                 left: 20.0,
  //                                 right: 20.0,
  //                               ),
  //                               child: InkWell(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     controller.text = globalName;
  //                                   });
  //                                   openBottmSheet("Name", 'name', globalName);
  //                                 },
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       bottom: 20, top: 10),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: <Widget>[
  //                                       Text(
  //                                         "Name",
  //                                         style: TextStyle(
  //                                             fontFamily: "Poppins-Medium",
  //                                             color: appColorBlack,
  //                                             fontSize: SizeConfig
  //                                                     .safeBlockHorizontal *
  //                                                 3,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                       SizedBox(
  //                                         width:
  //                                             SizeConfig.blockSizeHorizontal *
  //                                                 35,
  //                                         child: Text(
  //                                           globalName,
  //                                           maxLines: 1,
  //                                           textAlign: TextAlign.right,
  //                                           style: TextStyle(
  //                                               color: appColorBlack,
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.bold),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: SizeConfig.blockSizeVertical * 3,
  //                       ),
  //                       Material(
  //                         elevation: 5.0,
  //                         shadowColor: Colors.white,
  //                         borderRadius: BorderRadius.circular(10.0),
  //                         child: Container(
  //                           width: SizeConfig.screenWidth,
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(10.0),
  //                               border: Border.all(
  //                                   color: appColorBlack, width: 1.5)),
  //                           child: Padding(
  //                             padding: EdgeInsets.only(
  //                               top: 10.0,
  //                               bottom: 00.0,
  //                               left: 20.0,
  //                               right: 20.0,
  //                             ),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 setState(() {
  //                                   controller.text = globalWeb;
  //                                 });
  //                                 openBottmSheet(
  //                                     "Website", 'website', globalWeb);
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     bottom: 20, top: 10),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: <Widget>[
  //                                     Text(
  //                                       "Website",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins-Medium",
  //                                           color: appColorBlack,
  //                                           fontSize:
  //                                               SizeConfig.safeBlockHorizontal *
  //                                                   3,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                     SizedBox(
  //                                       width:
  //                                           SizeConfig.blockSizeHorizontal * 35,
  //                                       child: globalWeb.length > 0
  //                                           ? Text(
  //                                               globalWeb,
  //                                               maxLines: 1,
  //                                               textAlign: TextAlign.right,
  //                                               style: TextStyle(
  //                                                   color: appColorBlack,
  //                                                   fontWeight:
  //                                                       FontWeight.bold),
  //                                             )
  //                                           : Text(
  //                                               "www.xyz.com",
  //                                               maxLines: 1,
  //                                               textAlign: TextAlign.right,
  //                                               style: TextStyle(
  //                                                   color: Colors.grey,
  //                                                   fontSize: 13,
  //                                                   fontWeight:
  //                                                       FontWeight.bold),
  //                                             ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: SizeConfig.blockSizeVertical * 3,
  //                       ),
  //                       Material(
  //                         elevation: 5.0,
  //                         shadowColor: Colors.white,
  //                         borderRadius: BorderRadius.circular(10.0),
  //                         child: Container(
  //                           width: SizeConfig.screenWidth,
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(10.0),
  //                               border: Border.all(
  //                                   color: appColorBlack, width: 1.5)),
  //                           child: Padding(
  //                             padding: EdgeInsets.only(
  //                               top: 10.0,
  //                               bottom: 00.0,
  //                               left: 20.0,
  //                               right: 20.0,
  //                             ),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 setState(() {
  //                                   controller.text = globalBio;
  //                                 });
  //                                 openBottmSheet("Bio", 'bio', globalBio);
  //                               },
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     bottom: 20, top: 10),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: <Widget>[
  //                                     Text(
  //                                       "Bio",
  //                                       style: TextStyle(
  //                                           fontFamily: "Poppins-Medium",
  //                                           color: appColorBlack,
  //                                           fontSize:
  //                                               SizeConfig.safeBlockHorizontal *
  //                                                   3,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                     SizedBox(
  //                                       width:
  //                                           SizeConfig.blockSizeHorizontal * 35,
  //                                       child: globalBio.length > 0
  //                                           ? Text(
  //                                               globalBio,
  //                                               textAlign: TextAlign.right,
  //                                               maxLines: 1,
  //                                               style: TextStyle(
  //                                                   color: appColorBlack,
  //                                                   fontWeight:
  //                                                       FontWeight.bold),
  //                                             )
  //                                           : Text(
  //                                               "I am extrovert and love for photography",
  //                                               textAlign: TextAlign.right,
  //                                               maxLines: 1,
  //                                               style: TextStyle(
  //                                                   color: Colors.grey,
  //                                                   fontSize: 13,
  //                                                   fontWeight:
  //                                                       FontWeight.bold),
  //                                             ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(
  //                             top: 25, right: 20, left: 20, bottom: 25),
  //                         child: Container(
  //                           height: SizeConfig.blockSizeHorizontal * 12,
  //                           // ignore: deprecated_member_use
  //                           child: RaisedButton(
  //                             onPressed: () {
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => PersonalInfo()),
  //                               );
  //                             },
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(10.0)),
  //                             padding: const EdgeInsets.all(0.0),
  //                             child: Ink(
  //                               decoration: const BoxDecoration(
  //                                 gradient: LinearGradient(
  //                                     colors: [Colors.blue, Colors.blue],
  //                                     begin: const FractionalOffset(0.0, 0.0),
  //                                     end: const FractionalOffset(1.0, 0.0),
  //                                     stops: [0.0, 1.0],
  //                                     tileMode: TileMode.clamp),
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(10.0)),
  //                               ),
  //                               child: Container(
  //                                 constraints: const BoxConstraints(
  //                                     minWidth: 88.0,
  //                                     minHeight:
  //                                         36.0), // min sizes for Material buttons
  //                                 alignment: Alignment.center,
  //                                 child: const Text(
  //                                   'Personal information Settings',
  //                                   style: TextStyle(color: Colors.white),
  //                                   textAlign: TextAlign.center,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // openBottmSheet(String name, String fieldName, String value) {
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20.0),
  //         topRight: Radius.circular(20.0),
  //       ),
  //     ),
  //     context: context,
  //     builder: (context) {
  //       return SafeArea(
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //           ),
  //           child: Container(
  //             height: 500,
  //             child: ListView(
  //               children: <Widget>[
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(20.0),
  //                       topRight: Radius.circular(20.0),
  //                     ),
  //                   ),
  //                   height: 60,
  //                   child: Padding(
  //                     padding:
  //                         const EdgeInsets.only(left: 15, right: 15, top: 15),
  //                     child: Text(
  //                       name,
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w700,
  //                         fontStyle: FontStyle.normal,
  //                         //color: Colors.purple
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   height: 1,
  //                   color: Colors.grey,
  //                 ),
  //                 Container(
  //                     margin: EdgeInsets.only(left: 20.0, right: 20.0),
  //                     height: 120,
  //                     // color: Colors.red,
  //                     child: Padding(
  //                         padding: const EdgeInsets.only(
  //                             top: 20, right: 20, left: 20),
  //                         child: CustomtextField(
  //                           maxLines: 1,
  //                           textInputAction: TextInputAction.next,
  //                           controller: controller,
  //                           hintText: 'Enter $name',
  //                           prefixIcon: Icon(
  //                             Icons.person,
  //                             color: appColorGrey,
  //                             size: 30.0,
  //                           ),
  //                         ))),
  //                 Padding(
  //                   padding:
  //                       const EdgeInsets.only(left: 90, right: 90, top: 10),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Expanded(
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(left: 15, right: 10),
  //                           child: Container(
  //                             width: 70,
  //                             height: 35,
  //                             // ignore: deprecated_member_use
  //                             child: RaisedButton(
  //                               shape: new RoundedRectangleBorder(
  //                                 borderRadius: new BorderRadius.circular(8.0),
  //                               ),
  //                               onPressed: () {
  //                                 if (controller.text.length > 0) {
  //                                   FirebaseFirestore.instance
  //                                       .collection("user")
  //                                       .doc(globalID)
  //                                       .update({
  //                                     fieldName: controller.text
  //                                   }).then((value) {
  //                                     setState(() {
  //                                       if (fieldName == "name") {
  //                                         globalName = controller.text;
  //                                       } else if (fieldName == "website") {
  //                                         globalWeb = controller.text;
  //                                       } else if (fieldName == "bio") {
  //                                         globalBio = controller.text;
  //                                       }
  //                                     });
  //                                     Navigator.pop(context);
  //                                   });
  //                                 } else {
  //                                   Toast.show("Enter text", context,
  //                                       duration: Toast.LENGTH_SHORT,
  //                                       gravity: Toast.BOTTOM);
  //                                 }
  //                               },
  //                               color: buttonColorBlue,
  //                               textColor: Colors.white,
  //                               child: Text("Update".toUpperCase(),
  //                                   style: TextStyle(fontSize: 14)),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
