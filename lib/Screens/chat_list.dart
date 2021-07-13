import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pressfame_new/constant/global.dart';
import 'chat.dart';
import 'color_utils.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColorWhite,
        elevation: 1,
        title: Text(
          "Messenger",
          style: TextStyle(
              fontSize: 20, color: appColorBlack, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //     "assets/images/img.png",
                    //   ),
                    //   fit: BoxFit.fill,
                    //   alignment: Alignment.topCenter,
                    //   colorFilter: new ColorFilter.mode(
                    //       Colors.blue.withOpacity(0.5), BlendMode.dstATop),
                    // ),
                  ),
                  child: friendListToMessage(globalID)),
            ),
          ],
        ),
      ),
    );
  }

  Widget friendListToMessage(String userData) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatList")
          .doc(userData)
          .collection(userData)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: snapshot.data.docs.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      List chatList = snapshot.data.docs;
                      return buildItem(chatList, index);
                    },
                  )
                : Center(
                    child: Text("Currently you don't have any messages"),
                  ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CupertinoActivityIndicator(),
              ]),
        );
      },
    );
  }

  Widget buildItem(List chatList, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (chatList[index].data().containsKey("chatType") &&
                  chatList[index]['chatType'] == "group") {
                // Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //         builder: (context) => GroupChat(
                //             peerID: chatList[index]['id'],
                //             peerUrl: chatList[index]['profileImage'],
                //             peerName: chatList[index]['name'])));
              } else {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => Chat(
                            peerID: chatList[index]['id'],
                            peerUrl: chatList[index]['profileImage'],
                            peerName: chatList[index]['name'])));
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 8),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: Container(
                      decoration: new BoxDecoration(
                          //color: Colors.grey[300],
                          borderRadius:
                              new BorderRadius.all(Radius.circular(0.0))),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 60),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, top: 10, right: 40, bottom: 5),
                                  child: Container(
                                    // color: Colors.purple,
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          // color: Colors.yellow,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              180,
                                          child: Text(
                                            chatList[index]['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appColorBlack,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Text(
                                              DateFormat('dd MMM yyyy, kk:mm')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(chatList[
                                                                  index]
                                                              ['timestamp']))),
                                              style: TextStyle(
                                                  color: HexColor("#343e57"),
                                                  fontSize: 11.0,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Container(
                                            // color: Colors.red,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            height: 20,
                                            child: Text(
                                              chatList[index]['type'] != null &&
                                                      chatList[index]['type'] ==
                                                          1
                                                  ? "📷 Image"
                                                  : chatList[index]['content'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: appColorGrey,
                                                fontSize: 12,
                                                fontFamily: "Poppins-Medium",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: int.parse(chatList[index]['badge']) > 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 30,
                                        child: Text(
                                          chatList[index]['badge'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      )
                                    : Container(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: appColorBlack,
                                          size: 25.0,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 12),
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Material(
                        child: chatList[index]['profileImage'] != null
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
                                imageUrl: chatList[index]['profileImage'],
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
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black45,
            height: 0.5,
          ),
        ],
      ),
    );
  }

  Widget friendName(AsyncSnapshot friendListSnapshot, int index) {
    return Container(
      width: 200,
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text:
                "${friendListSnapshot.data["firstname"]} ${friendListSnapshot.data["lastname"]}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          )
        ]),
      ),
    );
  }

  Widget messageButton(AsyncSnapshot friendListSnapshot, int index) {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
        "Message",
        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
      ),
      onPressed: () {},
    );
  }
}
