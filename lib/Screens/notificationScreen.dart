import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Notification/notification.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:timeago/timeago.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _Discover4State createState() => _Discover4State();
}

class _Discover4State extends State<NotificationScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
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
              "Activity",
              style: TextStyle(
                fontSize: 20,
                color: appColorBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: appColorBlack,
                  size: 20,
                )),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("notification")
                      .where("idTo", isEqualTo: globalID)
                      .orderBy(FieldPath.documentId, descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: snapshot.data.docs.length > 0
                            ? ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, int index) {
                                  return buildItem(snapshot.data.docs[index]);
                                },
                              )
                            : Center(
                                child: Text(
                                    "Currently you don't have any notifications"),
                              ),
                      );
                    }
                    return Center(
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              CupertinoActivityIndicator(),
                            ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buildItem(list) {
    return list['idFrom'].length > 0
        ? FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('user')
                .doc(list['idFrom'])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return InkWell(
                  onTap: () {
                    if (list['idFrom'] != globalID)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PublicProfile(
                                  peerId: list['idFrom'],
                                )),
                      );
                  },
                  child: notificationWidget(
                      snapshot.data.data()['img'],
                      snapshot.data.data()['name'],
                      list["message"],
                      list["timestamp"],
                      list["type"],
                      list["idFrom"],
                      list["redirectId"]),
                );

              return Container();
            })
        : Container();
  }

  Widget notificationWidget(String image, String name, String msg, String time,
      String type, String idFrom, projectId) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                    ),
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Material(
                    child: image != null
                        ? CachedNetworkImage(
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
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.person,
                              size: 25,
                            ),
                          ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: SizedBox(
                      //  width: 150,
                      child: RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: 14.0,
                            //color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                              text: name,
                              style: TextStyle(
                                  color: appColorBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  fontFamily: "Poppins-Medium"),
                            ),
                            new TextSpan(
                              text: " " + msg,
                              style: TextStyle(
                                  color: appColorBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                  fontFamily: "Poppins-Medium"),
                            ),
                            TextSpan(
                                text: " " +
                                    format(DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(
                                      time,
                                    ))),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 20),
                type == 'request'
                    ? Row(
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: appColorBlack, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 7.7,
                                    height: SizeConfig.blockSizeVertical * 4,
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                                onTap: () {
                                  acceptRequet(idFrom, time);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                          ClipOval(
                            child: Material(
                              color: Color(0xFF8A63BF), // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: SizeConfig.blockSizeHorizontal * 7.7,
                                    height: SizeConfig.blockSizeVertical * 4,
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                                onTap: () {
                                  rejectRequest(idFrom, time);
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                        ],
                      )
                    : type == 'requestProject'
                        ? Row(
                            children: <Widget>[
                              ClipOval(
                                child: Material(
                                  color: appColorBlack, // button color
                                  child: InkWell(
                                    splashColor: Colors.red, // inkwell color
                                    child: SizedBox(
                                        width: SizeConfig.blockSizeHorizontal *
                                            7.7,
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                        child: Icon(
                                          Icons.check,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                    onTap: () {
                                      acceptprojectRequet(
                                          idFrom, time, projectId);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: SizeConfig.blockSizeHorizontal * 2),
                              ClipOval(
                                child: Material(
                                  color: Color(0xFF8A63BF), // button color
                                  child: InkWell(
                                    splashColor: Colors.red, // inkwell color
                                    child: SizedBox(
                                        width: SizeConfig.blockSizeHorizontal *
                                            7.7,
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                    onTap: () {
                                      rejectProjectRequest(
                                          idFrom, time, projectId);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                              ),
                            ],
                          )
                        : Container()
                // Padding(
                //   padding: const EdgeInsets.only(right: 10),
                //   child: Card(
                //     elevation: 4.0,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(0.0)),
                //     child: Container(
                //       height: 40,
                //       width: 45,
                //       decoration: BoxDecoration(
                //           color: Colors.grey[200],
                //           border: Border.all(
                //             color: Colors
                //                 .black, //                   <--- border color
                //             width: 1,
                //           ),
                //           borderRadius: BorderRadius.circular(0.0)),
                //       child: ClipRRect(
                //           borderRadius: BorderRadius.circular(0),
                //           child: image.length > 0
                //               ? Image.network(
                //                   image,
                //                   fit: BoxFit.cover,
                //                 )
                //               : Icon(
                //                   Icons.person,
                //                   color: Colors.grey,
                //                   size: 20,
                //                 )),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  acceptRequet(peerId, documentId) {
    setState(() {
      var ids = globalrFollowers;
      ids.add(peerId);
      globalrFollowers = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(peerId).set({
      "following": FieldValue.arrayUnion([globalID])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection("user").doc(globalID).set({
        "followers": FieldValue.arrayUnion([peerId])
      }, SetOptions(merge: true)).then((value) {
        removeRequestFunction(peerId, documentId);
      });
    });
  }

  removeRequestFunction(peerId, documentId) async {
    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "requested": FieldValue.arrayRemove([peerId])
    }, SetOptions(merge: true)).then((value) async {
      FirebaseFirestore.instance
          .collection("notification")
          .doc(documentId)
          .update({
        "type": 'following',
        "message": 'started following you',
      });
    }).then((value) {
      setNotificationData(
          peerId, 'following', "accept your following request", peerId);
    });
  }

  rejectRequest(peerId, documentId) {
    FirebaseFirestore.instance
        .collection("notification")
        .doc(documentId)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("user").doc(globalID).set({
        "requested": FieldValue.arrayRemove([peerId])
      }, SetOptions(merge: true));
    });
  }

  acceptprojectRequet(peerId, documentId, projectId) {
    FirebaseFirestore.instance.collection("project").doc(projectId).set({
      "projectTeam": FieldValue.arrayUnion([peerId]),
      "requested": FieldValue.arrayRemove([peerId])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance
          .collection("notification")
          .doc(documentId)
          .delete();
    });
  }

  rejectProjectRequest(peerId, documentId, projectId) {
    FirebaseFirestore.instance.collection("project").doc(projectId).set({
      "requested": FieldValue.arrayRemove([peerId])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance
          .collection("notification")
          .doc(documentId)
          .delete();
    });
  }
}
