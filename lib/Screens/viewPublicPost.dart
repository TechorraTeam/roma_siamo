import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pressfame_new/Notification/notification.dart';
import 'package:pressfame_new/Screens/comments.dart';
import 'package:pressfame_new/Screens/profile.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/Screens/sharePostScreen.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/Screens/videoView.dart';
import 'package:pressfame_new/constant/global.dart';
import 'dart:math' as math;
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:timeago/timeago.dart';

// ignore: must_be_immutable
class ViewPublicPost extends StatefulWidget {
  String id;
  ViewPublicPost({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ViewPublicPost> {
  @override
  void initState() {
    super.initState();
  }

  bool show = false;

  startTime() async {
    var _duration = new Duration(milliseconds: 700);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    setState(() {
      show = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
          backgroundColor: appColorWhite,
          appBar: AppBar(
            backgroundColor: appColorWhite,
            elevation: 0,
            title: Text(
              "Snapta",
              style: GoogleFonts.pacifico(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: appColorBlack),
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
          ),
          body: SingleChildScrollView(child: allPost(context))),
    );
  }

  Widget allPost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColor)));
          } else {
            return postDetails(snapshot.data);
          }
        },
      ),
    );
  }

  Widget postDetails(DocumentSnapshot document) {
    return Column(
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
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            document['userName'],
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                color: appColorBlack),
                          ),
                          Row(
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
                      )
                    : Text(
                        document['userName'],
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontFamily: "Poppins-Medium",
                            color: appColorBlack),
                      ),
                Expanded(
                  child: Container(),
                ),
                document['idFrom'] == globalID
                    ? PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PagesWidget()),
                                  );
                                  FirebaseFirestore.instance
                                      .collection("post")
                                      .doc(document['timestamp'])
                                      .delete();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text("Delete"),
                                )),
                          ),
                        ],
                      )
                    : Container()
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
                      child: Icon(
                      CupertinoIcons.heart_fill,
                      color: Colors.red,
                      size: 100,
                    )
                      //Image.asset('assets/images/like.gif', height: 50)
                      )
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
                tooltip: 'share',
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
                        'View All ' +
                            document["comments"].length.toString() +
                            ' Comments',
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
}
