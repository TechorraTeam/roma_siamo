import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

var userList = [];
String globalID = '';
String globalName = '';
String globalImage = '';
String globalToken = '';
String globalBio = '';
String globalWeb = '';
String globalStatus = '';
String globalLocation = '';
String globalPhone = '';
String globalGender = '';
String globalBday = '';
String globalEmail = '';
var globalrFollowing = [];
var globalrFollowers = [];
var globalrBookmarkList = [];
var globalRequested = [];
bool globalPrivacy;

SharedPreferences preferences;
Color appColor = Color(0XFF297EC4);
const Color appColorGreen = Color(0XFF4354AE);
Color appColorPurple = Color(0XFF7d45cf);
const Color appColorPurpel = Color(0XFF550BC1);
const Color appColorBlue = Color(0XFF3e65dd);
Color appColorWhite = Colors.white;

Color fontColorGrey = Colors.grey[800];
Color appColorGrey = Colors.grey[600];
Color appColorBlack = Colors.black;
Color appColorYellow = Color(0xffFFC000);
Color iconColor = Colors.grey[800];
Color fontColorBlue = Colors.blue;
Color buttonColorBlue = Colors.blue;

bool showLoader = false;

String serverKey =
    'AAAAupZgIbg:APA91bELaqXMVzLrzQRjU1NTQRbZlI6iqqQ76U2DaqNO6izr2Q3Ej-OBTo1Z31sH3Je1BXeSHV3s2a46KJoKRyE0hAqjUFO4Bt7VIlCrNuFeUBs3e3Elp_vrLOPZOLBAKaFh5vuWLiNi';

dynamic safeQueries(BuildContext context) {
  return (MediaQuery.of(context).size.height >= 812.0 ||
      MediaQuery.of(context).size.height == 812.0 ||
      (MediaQuery.of(context).size.height >= 812.0 &&
          MediaQuery.of(context).size.height <= 896.0 &&
          Platform.isIOS));
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final Alignment alignment;
  final String fontFamily;

  const CustomText(
      {Key key,
      this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.alignment,
      this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment,
        child: Text(' $text',
            style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: fontFamily)));
  }
}

// ignore: must_be_immutable
class FormtextField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  FormtextField({
    this.keyboardType,
    this.textCapitalization,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  FormtextFieldState createState() => FormtextFieldState();
}

class FormtextFieldState extends State<FormtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.red),
        errorText: widget.errorText,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.8),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

showAlert({BuildContext context, String title, String content}) {
  return showDialog(
    context: context,
    builder: (_) => Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 160,
            ),
            child: Container(
                width: MediaQuery.of(context).size.width - 30,
                // height: MediaQuery.of(context).size.height - 300,
                child: SingleChildScrollView(
                  child: _buildAlertContainer(context, title, content),
                )),
          ),
        ),
      ),
    ),
  );
}

Widget _buildAlertContainer(
    BuildContext context, String title, String content) {
  return Container(
    height: 300,
    width: MediaQuery.of(context).size.width - 100,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        Container(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: 18),
        ),
        Container(height: 20),
        SizedBox(
          width: 130,
          height: 45,
          // ignore: deprecated_member_use
          child: OutlineButton(
            child: Text("OK"),
            borderSide: BorderSide(color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}

// _messages(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 10, left: 15.0, bottom: 10.0),
//     child: GestureDetector(
//       onTap: () {
//         prefix0.Navigator.pop(context);
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => MessageList()));
//       },
//       child: Row(
//         children: <Widget>[
//           Icon(Icons.message, color: appColor),
//           Container(width: 5.0),
//           Text(
//             "Messages",
//             style: TextStyle(
//                 fontSize: 20.0, color: appColor, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     ),
//   );
// }

closeKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

actionAlertBox(
    {BuildContext context, Widget title, Widget content, Function onPressed}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: content,
        // ignore: deprecated_member_use
        actions: <Widget>[FlatButton(child: Text('OK'), onPressed: onPressed)],
      );
    },
  );
}

class CustomButtom extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  CustomButtom({
    this.color,
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: color,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: appColorGreen, width: 0),
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: onPressed,
    );
  }
}

Widget customTextField(
    {String hintText,
    String labelText,
    int maxLines = 1,
    Widget prefixIcon,
    Function onTap,
    TextEditingController controller,
    TextInputType keyboardType,
    List<TextInputFormatter> inputFormatters}) {
  return TextField(
    keyboardType: keyboardType,
    maxLines: maxLines,
    onTap: onTap,
    controller: controller,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey[500]),
      hintStyle: TextStyle(color: Colors.grey[500]),
      contentPadding: EdgeInsets.only(top: 30, left: 15.0),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400])),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400])),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[400])),
    ),
  );
}

void errorDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
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
            Text(message),
            Container(height: 15.0),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width - 100,
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      );
    },
  );
}

void indicatorDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return null;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}

// ignore: must_be_immutable
class CustomtextField extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  CustomtextField({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _CustomtextFieldState createState() => _CustomtextFieldState();
}

class _CustomtextFieldState extends State<CustomtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black, fontSize: 14),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.white),
        errorText: widget.errorText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: fontColorGrey, fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorGrey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorGrey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

Widget loader() {
  return Container(
    height: 60,
    width: 60,
    padding: EdgeInsets.all(15.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.black),
    child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(appColorYellow)),
  );
}

simpleAlertBox({BuildContext context, Widget title, Widget content}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

// class Loader {
//   void showIndicator(BuildContext context) {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//             child: Material(
//           type: MaterialType.transparency,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.black.withOpacity(0.7),
//               ),
//               Center(
//                 child: SpinKitWave(
//                     color: Colors.white, type: SpinKitWaveType.start),
//               )
//             ],
//           ),
//         ));
//       },
//     );
//   }

//   void hideIndicator(BuildContext context) {
//     Navigator.pop(context);
//   }
// }
class DropListModel {
  DropListModel(this.listOptionItems);

  final List<OptionItem> listOptionItems;
}

class OptionItem {
  final String id;
  final String title;

  OptionItem({@required this.id, @required this.title});
}

class SelectDropList extends StatefulWidget {
  final OptionItem itemSelected;
  final DropListModel dropListModel;
  final Function(OptionItem optionItem) onOptionSelected;

  SelectDropList(this.itemSelected, this.dropListModel, this.onOptionSelected);

  @override
  _SelectDropListState createState() =>
      _SelectDropListState(itemSelected, dropListModel);
}

class _SelectDropListState extends State<SelectDropList>
    with SingleTickerProviderStateMixin {
  OptionItem optionItemSelected;
  final DropListModel dropListModel;

  AnimationController expandController;
  Animation<double> animation;

  bool isShow = false;

  _SelectDropListState(this.optionItemSelected, this.dropListModel);

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[200],
              // boxShadow: [
              //   BoxShadow(
              //       blurRadius: 10, color: Colors.black26, offset: Offset(0, 2))
              // ],
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Icon(
                //   Icons.card_travel,
                //   color: Color(0xFF307DF1),
                // ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    this.isShow = !this.isShow;
                    _runExpandCheck();
                    setState(() {});
                  },
                  child: Text(
                    optionItemSelected.title,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                )),
                Align(
                  alignment: Alignment(1, 0),
                  child: Icon(
                    isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Container(
                    child: _buildDropListOptions(
                        dropListModel.listOptionItems, context),
                  ))),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Column _buildDropListOptions(List<OptionItem> items, BuildContext context) {
    return Column(
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(OptionItem item, BuildContext context) {
    return Container(
      // color: Colors.red,

      child: Padding(
        padding: const EdgeInsets.only(left: 26.0, top: 5, bottom: 5),
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    //
                    border: Border(
                        top: BorderSide(color: Colors.grey[200], width: 1)),
                  ),
                  child: Text(item.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          onTap: () {
            this.optionItemSelected = item;
            isShow = false;
            expandController.reverse();
            widget.onOptionSelected(item);
          },
        ),
      ),
    );
  }
}

Widget msgWidget(BuildContext context) {
  return globalID.length > 0
      ? Padding(
          padding: const EdgeInsets.only(top: 0, right: 0),
          child: Container(
            alignment: Alignment.center,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatList")
                  .doc(globalID)
                  .collection(globalID)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    alignment: Alignment.center,
                    height: 10,
                    width: 10,
                    child: CupertinoActivityIndicator(),
                  );
                }
                int messageCount = 0;
                for (var data in snapshot.data.docs) {
                  messageCount = messageCount + int.parse(data['badge']);
                }
                return messageCount > 0
                    ? Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        fit: StackFit.loose,
                        children: [
                          msgIcon(context),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0, left: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: appColorBlack),
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              child: Text(
                                '$messageCount',
                                style: TextStyle(
                                    color: appColorWhite, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      )
                    : msgIcon(context);
              },
            ),
          ),
        )
      : Container();
}

Widget msgIcon(BuildContext context) {
  return Icon(
    CupertinoIcons.bolt_horizontal_circle,
    size: 27,
  );
}

Future<UploadTask> uploadFile2(File file) async {
  UploadTask uploadTask;

  // Create a Reference to the file
  var timeKey = new DateTime.now();
  Reference ref = FirebaseStorage.instance
      .ref()
      .child('profileImage')
      .child('/$timeKey.jpg');

  final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path});

  if (kIsWeb) {
    uploadTask = ref.putData(await file.readAsBytes(), metadata);
  } else {
    uploadTask = ref.putFile(File(file.path), metadata);
  }

  return Future.value(uploadTask);
}

toast(title, msg, BuildContext context) {
  Flushbar(
    title: title,
    message: msg,
    titleColor: appColorBlack,
    messageColor: appColorBlack,
    icon: Icon(
      title == "Error" ? Icons.error : Icons.check,
      color: appColorBlack,
    ),
    backgroundColor: Colors.grey[300],
    duration: Duration(seconds: 2),
  ).show(context);
}

class SelectedButton2 extends StatelessWidget {
  final String title;
  final Function onPressed;
  SelectedButton2({
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: 30,
          decoration: BoxDecoration(
              color: appColorBlack,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Text(title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.white)),
          ))),
    );
  }
}

class UnSelectedButton2 extends StatelessWidget {
  final String title;
  final Function onPressed;
  UnSelectedButton2({
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: 30,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: Text(title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: appColorBlack)),
          ))),
    );
  }
}

// ignore: must_be_immutable
class CustomtextField3 extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;
  final textAlign;

  final Widget prefixIcon;
  CustomtextField3(
      {this.keyboardType,
      this.onTap,
      this.focusNode,
      this.textInputAction,
      this.onEditingComplate,
      this.onSubmitted,
      this.controller,
      this.maxLines,
      this.onChange,
      this.errorText,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      this.readOnly = false,
      this.autoFocus = false,
      this.prefixIcon,
      this.suffixIcon,
      this.textAlign});

  @override
  _CustomtextFieldState3 createState() => _CustomtextFieldState3();
}

class _CustomtextFieldState3 extends State<CustomtextField3> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: widget.textAlign,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.grey[600], fontSize: 14),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: false,
        //  fillColor: Colors.black.withOpacity(0.5),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        errorStyle: TextStyle(color: Colors.white),
        errorText: widget.errorText,

        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
      ),
    );
  }
}
