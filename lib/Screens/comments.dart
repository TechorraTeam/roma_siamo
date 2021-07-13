import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pressfame_new/Notification/notification.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

// ignore: must_be_immutable
class CommentsScreen extends StatefulWidget {
  String timestamp;
  String peerId;

  CommentsScreen({this.timestamp, this.peerId});

  @override
  _LoginPage1State createState() => _LoginPage1State();
}

class _LoginPage1State extends State<CommentsScreen> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              width: ScreenUtil.screenWidth,
              child: Stack(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Comments",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: appColorBlack,
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: appColorBlack,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _commentBody(widget.timestamp),
          ),
          Center(
            child: Container(
              margin: safeQueries(context) ? EdgeInsets.only(bottom: 25) : null,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                          controller: controller,
                          autofocus: true,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          // focusNode: focusNode,
                        ),
                      ),
                    ),
                  ),

                  // Button send message
                  Material(
                    child: new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 8.0),
                      child: new IconButton(
                        icon: new Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty)
                            commentPost(controller.text, widget.timestamp,
                                widget.peerId);
                        },
                        // color: primaryColor,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              width: double.infinity,
              height: 50.0,
              decoration: new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(color: Colors.grey, width: 0.7)),
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _commentBody(timestamp) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          children: [
            Container(height: 10),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("post")
                  .where(FieldPath.documentId, isEqualTo: timestamp)
                  //.orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: snapshot.data.docs[0]["comments"].length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: commentWidget(
                                snapshot.data.docs[0]['comments'][index]
                                    ['name'],
                                snapshot.data.docs[0]['comments'][index]
                                    ['image'],
                                snapshot.data.docs[0]['comments'][index]
                                    ['content'],
                                snapshot.data.docs[0]['comments'][index]
                                    ['userId']),
                          );
                        },
                      )
                    : Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget commentWidget(
      String name, String image, String msg, String commenterId) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.only(left: 20, right: 10, bottom: 10),
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      child:
                          // peerUrl != null
                          //     ?
                          CachedNetworkImage(
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
                        imageUrl: image,
                        width: 45.0,
                        height: 45.0,
                        fit: BoxFit.cover,
                      ),
                      // : Padding(
                      //     padding: const EdgeInsets.all(10.0),
                      //     child: Icon(
                      //       Icons.person,
                      //       size: 25,
                      //     ),
                      //   ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(120.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                    Container(width: 15.0),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(height: 10.0),
                              Expanded(
                                child: RichText(
                                  text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: name,
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3.5,
                                              fontStyle: FontStyle.normal,
                                              color: appColorBlack,
                                              fontFamily: "Poppins-Medium",
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "  " + msg,
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3.2,
                                              color: Colors.black,
                                              fontFamily: "Poppins-Medium",
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 5,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        globalID == commenterId || globalID == widget.peerId
            ? IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  deleteComment(
                      widget.timestamp, commenterId, name, image, msg);
                },
              )
            : Container()
      ],
    );
  }

  commentPost(String content, String time, String peerId) {
    FirebaseFirestore.instance.collection('post').doc(time).set({
      "comments": FieldValue.arrayUnion([
        {
          "userId": globalID,
          "name": globalName,
          "image": globalImage,
          "content": content,
        }
      ])
    }, SetOptions(merge: true)).then((value) {
      if (peerId != globalID) {
        setNotificationData(
            peerId, 'comment', "commented ❝$content❞ on your post",time);
      }

      setState(() {
        controller.clear();
      });
    });
  }

  deleteComment(
      String time, String userId, String name, String image, String content) {
    FirebaseFirestore.instance.collection('post').doc(time).update(
      {
        "comments": FieldValue.arrayRemove([
          {
            "userId": userId,
            "name": name,
            "image": image,
            "content": content,
          }
        ])
      },
    );
  }
}
