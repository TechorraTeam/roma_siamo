import 'dart:async';

import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pressfame_new/Model/report_model.dart';
import 'package:pressfame_new/Notification/notification.dart';
import 'package:pressfame_new/Screens/comments.dart';
import 'package:pressfame_new/Screens/eula_screen.dart';
import 'package:pressfame_new/Screens/login.dart';
import 'package:pressfame_new/Screens/notificationScreen.dart';
import 'package:pressfame_new/Screens/profile.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/Screens/savedPost.dart';
import 'package:pressfame_new/Screens/search.dart';
import 'package:pressfame_new/Screens/sharePostScreen.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/Screens/terms_of_services.dart';
import 'package:pressfame_new/Screens/videoView.dart';
import 'package:pressfame_new/constant/global.dart';
import 'dart:math' as math;
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:pressfame_new/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController controller = new TextEditingController();
  var shareIdList = [];
  FancyDrawerController _controller;
  String groupChatId;
  bool show = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 500);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    setState(() {
      show = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FancyDrawerWrapper(
      backgroundColor: appColorWhite,
      controller: _controller,
      drawerItems: <Widget>[
        Row(
          children: [
            globalImage != null && globalImage.length > 0
                ? Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(),
                        image: DecorationImage(
                          image: NetworkImage(globalImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 70,
                    color: Colors.grey,
                  ),
          ],
        ),
        Text(
          'Hi'.tr + ' ' + globalName,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: appColorBlack),
        ),
        Container(height: 30),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PagesWidget()),
            );
          },
          child: Row(
            children: [
              Image.asset(
                'assets/images/home.png',
                height: 22,
                color: appColorBlack,
              ),
              Container(width: 10),
              Text(
                "home".tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: appColorBlack),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
                        back: true,
                      )),
            );
          },
          child: Row(
            children: [
              Image.asset('assets/images/account.png',
                  height: 22, color: appColorBlack),
              Container(width: 10),
              Text(
                "account".tr,
                style: TextStyle(
                  fontSize: 18,
                  color: appColorBlack,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedPost()),
            );
          },
          child: Row(
            children: [
              Image.asset('assets/images/save.png',
                  height: 22, color: appColorBlack),
              Container(width: 10),
              Text(
                "saved".tr,
                style: TextStyle(
                  fontSize: 18,
                  color: appColorBlack,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            String _url = 'https://www.ciroscognamiglio.it/';
            await canLaunch(_url)
                ? await launch(_url)
                : throw 'Could not launch $_url';
          },
          child: Row(
            children: [
              Image.asset('assets/images/help.png',
                  height: 22, color: appColorBlack),
              Container(width: 10),
              Text(
                "help".tr,
                style: TextStyle(
                  fontSize: 18,
                  color: appColorBlack,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => Get.to(EULAScreen()),
          child: Row(
            children: [
              Icon(Icons.privacy_tip_outlined,color: appColorBlack,size: 22,),
              Container(width: 10),
              Text(
                "EULA",
                style: TextStyle(
                  fontSize: 18,
                  color: appColorBlack,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => Get.to(TermsOfServices()),
          child: Row(
            children: [
              Icon(Icons.privacy_tip_outlined,color: appColorBlack,size: 22,),
              Container(width: 10),
              Text(
                "terms".tr,
                style: TextStyle(
                  fontSize: 18,
                  color: appColorBlack,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
        // InkWell(
        //   onTap: () {},
        //   child: Row(
        //     children: [
        //       Image.asset('assets/images/about.png',
        //           height: 24, color: appColorBlack),
        //       Container(width: 10),
        //       Text(
        //         "about".tr,
        //         style: TextStyle(
        //           fontSize: 18,
        //           color: appColorBlack,
        //           fontWeight: FontWeight.normal,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        InkWell(
          onTap: () async {
            _signOut().then((value) async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences
                  .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                  .then((_) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              });
            });
          },
          child: Row(
            children: [
              Image.asset('assets/images/logout.png',
                  height: 22, color: appColorBlack),
              Container(width: 10),
              Text(
                "log_out".tr,
                style: TextStyle(
                  fontSize: 18,
                  color: appColorBlack,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: appColorWhite,
              elevation: 0,
              title: Text(
                "Roma Siamo Voi",
                style: GoogleFonts.pacifico(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: appColorBlack),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    _controller.toggle();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: appColorBlack,
                    size: 30,
                  )),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.bell,
                    size: 25,
                    color: appColorBlack,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Search()),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.line_horizontal_3_decrease,
                    size: 30,
                    color: appColorBlack,
                  ),
                ),
                Container(width: 10),
              ],
            ),
            body: allPost(context)),
      ),
    );
  }

  List blockedUsers;
  Widget allPost(BuildContext context) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) async {
      if (value != null) {
        print(value.data());
        blockedUsers = value.get('blockedUsers');
      }
    });

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .orderBy('timestamp', descending: true)
            //.limit(limit)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColor)));
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                //controller: listScrollController,
                itemBuilder: (context, index) {
                  if (
                      // blockedUsers == null ||
                      snapshot.data.docs[index]["hideBy"].contains(globalID) ||
                          (blockedUsers ?? [])
                              .contains(snapshot.data.docs[index]["idFrom"])) {
                    return SizedBox();
                  } else {
                    return postDetails(snapshot.data.docs[index]);
                  }
                },
              ),
            );
          }
        });
  }

  Widget postDetails(DocumentSnapshot document) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            if (globalID == document['idFrom']) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(back: true)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PublicProfile(peerId: document['idFrom'])),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Row(
              children: <Widget>[
                document['userImage'].length > 0
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(document['userImage']),
                        radius: 22,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border:
                                Border.all(color: appColorBlack, width: 0.5),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/images/name.png",
                            height: 22,
                            color: appColorGrey,
                          ),
                        ),
                      ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 4,
                ),
                document['location'].length > 0
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              document['userName'],
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 3.5,
                                  color: appColorBlack),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 250,
                                  child: Text(
                                    document['location'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 3,
                                        fontFamily: "Poppins-Medium",
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Text(
                          document['userName'],
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              fontFamily: "Poppins-Medium",
                              color: appColorBlack),
                        ),
                      ),
                // SizedBox(
                //   width: 170,
                // ),
                /* ------------------------------ More button ----------------------------- */
                if (globalID != document['idFrom'])
                  IconButton(
                      onPressed: () {
                        // Navigator.of(context);

                        ReportModel reportModel = ReportModel(
                            reportByName: globalName,
                            reportByPic: globalImage,
                            reportTime: DateTime.now().millisecondsSinceEpoch,
                            reportById: globalID,
                            postByName: document['userName'],
                            postByPic: document['userImage'],
                            postById: document['idFrom'],
                            postRef: document.reference,
                            orderNo: 1,
                            status: 'pending');
                        _settingModalBottomSheet(context, reportModel);
                      },
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Colors.black,
                        size: 25,
                      )),
              ],
            ),
          ),
        ),
        Container(
          height: 2,
        ),
        InkWell(
          onDoubleTap: () {
            startTime();
            setState(() {
              show = true;
            });
            if (document['likes'].contains(globalID)) {
            } else {
              likePost(document['timestamp'], document['idFrom']);
            }
          },
          child: Stack(
            children: <Widget>[
              document['videoUrl'] == ''
                  ? Container(
                      constraints: BoxConstraints(
                        minHeight: 320,
                        maxHeight: 500,
                        maxWidth: double.infinity,
                        minWidth: double.infinity,
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CupertinoActivityIndicator(),
                          width: 35.0,
                          height: 35.0,
                          padding: EdgeInsets.all(10.0),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document['content'],
                        // width: 35.0,
                        // height: 35.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      // height: 300,
                      child: VideoView(
                        url: document['content'],
                      ),
                    ),
              show == true
                  ? Positioned.fill(
                      child: AnimatedOpacity(
                          opacity: show ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 700),
                          child: Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                            size: 100,
                          )))
                  : Container(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              document['likes'].contains(globalID)
                  ? IconButton(
                      icon: Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.red,
                        size: 25,
                      ),
                      onPressed: () {
                        unLikePost(document['timestamp']);
                      })
                  : IconButton(
                      icon: Icon(
                        CupertinoIcons.suit_heart,
                        color: appColorBlack,
                        size: 25,
                      ),
                      onPressed: () {
                        startTime();
                        setState(() {
                          show = true;
                        });
                        likePost(document['timestamp'], document['idFrom']);
                      },
                    ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.chat_bubble,
                    color: appColorBlack,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                                timestamp: document["timestamp"],
                                peerId: document["idFrom"],
                              )),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.paperplane,
                  color: appColorBlack,
                  size: 25,
                ),
                tooltip: 'share'.tr,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SharePostScrren(document: document)),
                  );
                },
              ),
              Expanded(
                child: Container(),
              ),
              globalrBookmarkList.contains(document['timestamp'])
                  ? IconButton(
                      icon: Icon(
                        CupertinoIcons.bookmark_fill,
                        size: 25,
                        color: appColorBlack,
                      ),
                      onPressed: () {
                        removeBookmark(document['timestamp']);
                      })
                  : IconButton(
                      icon: Icon(
                        CupertinoIcons.bookmark,
                        size: 25,
                        color: appColorBlack,
                      ),
                      onPressed: () {
                        addBookmark(document['timestamp']);
                      }),
              Container(width: 10),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: Text(
                document['likes'].length.toString() + " likes",
                style: TextStyle(
                    color: appColorBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                      fontSize: 14.0,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: document['userName'],
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontStyle: FontStyle.normal,
                              color: appColorBlack,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: " " + document["caption"],
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        document["comments"].length != 0
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              timestamp: document["timestamp"],
                              peerId: document["idFrom"],
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'view_all'.tr +
                            document["comments"].length.toString() +
                            'comments'.tr,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 3, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0, bottom: 20),
                child: Text(
                  format(DateTime.fromMillisecondsSinceEpoch(int.parse(
                    document["timestamp"],
                  ))),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> onSendMessage(
      String content,
      int type,
      String peerId,
      // ignore: non_constant_identifier_names
      String peerName,
      String peerImage) async {
    if (globalID.hashCode <= peerId.hashCode) {
      groupChatId = globalID + "-" + peerId;
    } else {
      groupChatId = peerId + "-" + globalID;
    }

    // type:   0 = text, 1 = image
    int badgeCount = 0;
    print(content);
    print(content.trim());
    if (content.trim() != '') {
      var documentReference = cloud.FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      cloud.FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': globalID,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }).then((onValue) async {
        await cloud.FirebaseFirestore.instance
            .collection("chatList")
            .doc(globalID)
            .collection(globalID)
            .doc(peerId)
            .set({
          'id': peerId,
          'name': peerName,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'badge': '0',
          'profileImage': peerImage,
        }).then((onValue) async {
          try {
            await cloud.FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerId)
                .collection(peerId)
                .doc(globalID)
                .get()
                .then((doc) async {
              debugPrint(doc["badge"]);
              if (doc["badge"] != null) {
                badgeCount = int.parse(doc["badge"]);
                await cloud.FirebaseFirestore.instance
                    .collection("chatList")
                    .doc(peerId)
                    .collection(peerId)
                    .doc(globalID)
                    .set({
                  'id': globalID,
                  'name': globalName,
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                  'content': content,
                  'badge': '${badgeCount + 1}',
                  'profileImage': globalImage,
                });
              }
            });
          } catch (e) {
            await cloud.FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerId)
                .collection(peerId)
                .doc(globalID)
                .set({
              'id': globalID,
              'name': globalName,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': '${badgeCount + 1}',
              'profileImage': globalImage,
            });
            print(e);
          }
        });
      });
    } else {
      // Fluttertoast.showToast(
      //     msg: 'Nothing to send', backgroundColor: Colors.red);
    }
  }

  Future<http.Response> createNotification(String sendNotification) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            "key=AAAAupZgIbg:APA91bELaqXMVzLrzQRjU1NTQRbZlI6iqqQ76U2DaqNO6izr2Q3Ej-OBTo1Z31sH3Je1BXeSHV3s2a46KJoKRyE0hAqjUFO4Bt7VIlCrNuFeUBs3e3Elp_vrLOPZOLBAKaFh5vuWLiNi"
//          HttpHeaders.authorizationHeader:
//              "key=AAAAdlUezOQ:APA91bH9mRwxoUQujG3NGnkAmV0XFGW8zYGseKjPmLQOZqX9pcl4Zzm32qoNgBacwPvVPkRrH7auS6VGEDti558GpYAmiksVI0mPZf9N-ltZrKQQlh6TnTL5_tz3HdtRCso1hK1dqH2v"
      },
      body: sendNotification,
    );
    return response;
  }

  likePost(time, peerId) {
    FirebaseFirestore.instance.collection("post").doc(time).set({
      "likes": FieldValue.arrayUnion([globalID])
    }, SetOptions(merge: true)).then((value) {
      if (peerId != globalID) {
        setNotificationData(peerId, 'like', "liked your post", time);
      }
    });
  }

  unLikePost(time) {
    FirebaseFirestore.instance.collection("post").doc(time).set({
      "likes": FieldValue.arrayRemove([globalID])
    }, SetOptions(merge: true)).then((value) {
      setState(() {});
    });
  }

  addBookmark(time) {
    setState(() {
      var ids = globalrBookmarkList;
      ids.add(time);
      globalrBookmarkList = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "bookmark": FieldValue.arrayUnion([time])
    }, SetOptions(merge: true));
  }

  removeBookmark(time) {
    setState(() {
      var ids = globalrBookmarkList;
      ids.remove(time);
      globalrBookmarkList = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "bookmark": FieldValue.arrayRemove([time])
    }, SetOptions(merge: true));
  }

  getUserData() async {
    User user = firebaseAuth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get()
          .then((peerData) {
        if (peerData.exists) {
          if (mounted)
            setState(() {
              globalID = user.uid;
              globalName = peerData['name'];
              globalImage = peerData['img'];
              globalBio = peerData['bio'];
              globalWeb = peerData['website'];
              globalStatus = peerData['status'];
              globalLocation = peerData['location'];
              globalrFollowing = peerData['following'];
              globalrFollowers = peerData['followers'];
              globalrBookmarkList = peerData['bookmark'];
              globalRequested = peerData['requested'];
              globalPrivacy = peerData['privacy'];
              globalPhone = peerData['mobile'];
              globalGender = peerData['gender'];
              globalBday = peerData['bday'];
              globalEmail = peerData['email'];
            });
        }
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

/* --------------------------- Report Bottom Sheet -------------------------- */

  void _settingModalBottomSheet(context, ReportModel reportModel) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                    title: Text("report_post".tr),
                    onTap: () {
                      reportPost(reportModel);
                      hidePost(globalID, reportModel.postRef);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    title: Text("hide_post".tr),
                    onTap: () {
                      hidePost(globalID, reportModel.postRef);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    title: Text("block_user".tr),
                    onTap: () {
                      blockUser(reportModel.postRef);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    title: Text("Cancel".tr),
                    onTap: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          );
        });
//InViewNotifierWidget
// Stack(
//   children: [
//     Center(
//       child: InViewNotifierList(
//           initialInViewIds: ['0'],
//           isInViewPortCondition: (double deltaTop,
//               double deltaBottom, double viewPortDimension) {
//             return deltaTop < (0.3 * viewPortDimension) &&
//                 deltaBottom > (0.5 * viewPortDimension);
//           },
//           padding: EdgeInsets.only(bottom: 10),
//           shrinkWrap: true,
//           itemCount: snapshot.data.docs.length,
//           builder: (context, index) {
//             return LayoutBuilder(builder:
//                 (BuildContext context, BoxConstraints constraints) {
//               return InViewNotifierWidget(
//                   id: '$index',
//                   builder: (BuildContext context, bool isInView,
//                       Widget child) {
//                     return postDetails(
//                         snapshot.data.docs[index], isInView);
//                   });
//             });
//           }),
//     ),
//     Align(
//       alignment: Alignment.center,
//       child: Container(
//         height: 1.0,
//         color: Colors.redAccent,
//       ),
//     )
//   ],
// ),
  }

  /* ------------------------- report save to firebase ------------------------ */
  reportPost(ReportModel reportModel) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("ReportedPost")
        .where("PostRef", isEqualTo: reportModel.postRef)
        .where("ReportById", isEqualTo: reportModel.reportById)
        .get();
    if (snapshot.docs.length < 1) {
      cloud.FirebaseFirestore.instance
          .collection("ReportedPost")
          .add(reportModel.toMap());
      Get.snackbar("success".tr, "reported_succesfully".tr,
          backgroundColor: Colors.green.withOpacity(0.4));
    } else {
      Get.snackbar("Alert".tr, "Already Reported".tr,
          backgroundColor: Colors.red.withOpacity(0.4));
    }
  }

  hidePost(userId, DocumentReference postRef) async {
    var post = await postRef.get();
    if (post.exists) {
      List hideBy = post["hideBy"];
      hideBy.add(userId);

      postRef.update({"hideBy": hideBy});
    }
  }

  blockUser(DocumentReference postRef) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) async {
      if (value != null) {
        DocumentSnapshot post = await postRef.get();
        print(value.data());
        List blockedOnes = value.data()['blockedUsers'] ?? [];
        String idFrom = post.get('idFrom');
        (blockedOnes ?? []).add(idFrom);

        FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'blockedUsers': blockedOnes}).then((value) {
          setState(() {
            blockedUsers = blockedOnes;
          });
          Get.snackbar("success".tr, "user_blocked_success".tr,
              backgroundColor: Colors.green.withOpacity(0.4));
        });
      }
    });
  }
}
