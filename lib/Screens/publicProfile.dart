import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';
import 'package:pressfame_new/Notification/notification.dart';
import 'package:pressfame_new/Screens/chat.dart';
import 'package:pressfame_new/Screens/viewPublicPost.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

// ignore: must_be_immutable
class PublicProfile extends StatefulWidget {
  String peerId;
  PublicProfile({this.peerId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<PublicProfile> {
  String totalPost = '0';
  @override
  void initState() {
    getTotalPost();
    super.initState();
  }

  getTotalPost() {
    FirebaseFirestore.instance
        .collection('post')
        .where("idFrom", isEqualTo: widget.peerId)
        .get()
        .then((sanp) {
      if (mounted)
        setState(() {
          totalPost = sanp.docs.length.toString();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorWhite,
          elevation: 0,
          title: Text(
            "",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(widget.peerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(appColor)));
              } else {
                return _userInfo(context, snapshot.data);
              }
            },
          ),
        ));
  }

  Widget _userInfo(BuildContext context, DocumentSnapshot document) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[600], width: 1),
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: CircleAvatar(
                                    backgroundImage: document['img'].length > 0
                                        ? NetworkImage(document['img'])
                                        : NetworkImage(
                                            "${"https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png"}"),
                                    radius: 45,
                                  ),
                                ),
                              ),
                              _buildCategory("Posts", totalPost),
                              InkWell(
                                  child: _buildCategory("Following",
                                      document['following'].length.toString())),
                              InkWell(
                                child: _buildCategory("Followers",
                                    document['followers'].length.toString()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            document['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: appColorBlack),
                          ),
                        ),
                        SizedBox(height: 3),
                        document['bio'].length > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  document['bio'],
                                  //maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: appColorBlack),
                                ),
                              )
                            : Container(),
                        document['website'].length > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Linkable(
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 16),
                                  text: document['website'],
                                ),
                              )
                            : Container(),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 50),
                            Expanded(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 30,
                                child: document['requested'].contains(globalID)
                                    ?
                                    // ignore: deprecated_member_use
                                    FlatButton(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey[600]),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Text(
                                          'Requested',
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontSize: 12),
                                        ),
                                        color: Colors.white,
                                        onPressed: () {
                                          unRequestFunction(widget.peerId);
                                        },
                                      )
                                    : globalrFollowing.contains(widget.peerId)
                                        ?

                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey[600]),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Text(
                                              'Following',
                                              style: TextStyle(
                                                  color: appColorBlack,
                                                  fontSize: 12),
                                            ),
                                            color: Colors.white,
                                            onPressed: () {
                                              unFollowFunction(widget.peerId);
                                            },
                                          )
                                        :
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Text(
                                              'Follow',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            color: buttonColorBlue,
                                            onPressed: () {
                                              if (document["privacy"] == true) {
                                                requestFunction(widget.peerId);
                                              } else {
                                                followFunction(widget.peerId);
                                              }
                                            },
                                          ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 30,
                                // ignore: deprecated_member_use
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey[600]),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Message',
                                    style: TextStyle(
                                        color: appColorBlack, fontSize: 12),
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chat(
                                                peerID: widget.peerId,
                                                peerUrl: document['img'],
                                                peerName: document['name'],
                                              )),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 50),
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 50),
                            child: myPost(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: appColorBlack),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
              color: appColorBlack, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget myPost() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .where("idFrom", isEqualTo: widget.peerId)
              //.orderBy('timestamp', descending: true)
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
                child: GridView.builder(
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  padding: EdgeInsets.all(5),
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 200 / 200,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewPublicPost(
                                      id: snapshot.data.docs[index]
                                          ['timestamp'])),
                            );
                          },
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
                            imageUrl:
                                snapshot.data.docs[index]['videoUrl'].length > 0
                                    ? snapshot.data.docs[index]['videoUrl']
                                    : snapshot.data.docs[index]['content'],
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                ),
              );
            }
          },
        ));
  }

  followFunction(peerId) {
    setState(() {
      var ids = globalrFollowing;
      ids.add(peerId);
      globalrFollowing = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "following": FieldValue.arrayUnion([peerId])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection("user").doc(peerId).set({
        "followers": FieldValue.arrayUnion([globalID])
      }, SetOptions(merge: true)).then((value) {
        setNotificationData(
            peerId, 'following', "started following you", peerId);
      });
    });
  }

  requestFunction(peerId) {
    FirebaseFirestore.instance.collection("user").doc(peerId).set({
      "requested": FieldValue.arrayUnion([globalID])
    }, SetOptions(merge: true)).then((value) {
      setNotificationData(peerId, 'request', "send you friend request", peerId);
    });
  }

  unRequestFunction(peerId) async {
    FirebaseFirestore.instance.collection("user").doc(peerId).set({
      "requested": FieldValue.arrayRemove([globalID])
    }, SetOptions(merge: true)).then((value) async {
      CollectionReference col1 =
          FirebaseFirestore.instance.collection('notification');
      final snapshots = col1.snapshots().map((snapshot) => snapshot.docs.where(
          (doc) =>
              doc["idFrom"] == globalID &&
              doc["idTo"] == peerId &&
              doc["type"] == 'request'));

      snapshots.first.then((value) {
        value.forEach((document) {
          document.reference.delete();
        });
      });
    });
  }

  unFollowFunction(peerId) {
    setState(() {
      var ids = globalrFollowing;
      ids.remove(peerId);
      globalrFollowing = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "following": FieldValue.arrayRemove([peerId])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection("user").doc(peerId).set({
        "followers": FieldValue.arrayRemove([globalID])
      }, SetOptions(merge: true));
    });
  }
}
