import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:toast/toast.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  bool isSwitched = false;

  @override
  void initState() {
    isSwitched = globalPrivacy;

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
            "Personal Information",
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
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PagesWidget()),
                  );
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
        body: isLoading == true ? Center(child: loader()) : _userInfo());
  }

  Widget _userInfo() {
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
                SizedBox(height: 50),
                Text(
                  'This information won\'t be display \n in public profile',
                  style: TextStyle(
                      color: appColorBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins-Medium'),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: appColorBlack, width: 1.5)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 00.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Email",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Medium",
                                            color: appColorBlack,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 55,
                                        child: Text(
                                          globalEmail,
                                          maxLines: 1,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: appColorBlack, width: 1.5)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 00.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    controller.text = globalPhone;
                                  });
                                  openBottmSheet(
                                      "Phone", 'mobile', globalPhone);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Phone",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Medium",
                                            color: appColorBlack,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 35,
                                        child: globalPhone.length > 0
                                            ? Text(
                                                globalPhone,
                                                maxLines: 1,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "45645645645",
                                                maxLines: 1,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: appColorBlack, width: 1.5)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 00.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    controller.text = globalGender;
                                  });
                                  openBottmSheet(
                                      "Gender", 'gender', globalGender);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Gender",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Medium",
                                            color: appColorBlack,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 35,
                                        child: globalGender.length > 0
                                            ? Text(
                                                globalGender,
                                                maxLines: 1,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "Male/Female",
                                                maxLines: 1,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: appColorBlack, width: 1.5)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 00.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    controller.text = globalBday;
                                  });
                                  openBottmSheet(
                                      "Birthday", 'bday', globalBday);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Birthday",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Medium",
                                            color: appColorBlack,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 35,
                                        child: globalBday.length > 0
                                            ? Text(
                                                globalBday,
                                                maxLines: 1,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "12/2/2001",
                                                maxLines: 1,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: appColorBlack, width: 1.5)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 0.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10, top: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "privacy",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Medium",
                                            color: appColorBlack,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Switch(
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;

                                              FirebaseFirestore.instance
                                                  .collection("user")
                                                  .doc(globalID)
                                                  .update({
                                                'privacy': value
                                              }).then((_) {
                                                setState(() {
                                                  globalPrivacy = value;
                                                });
                                              });
                                            });
                                          },
                                          activeColor: appColorBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openBottmSheet(String name, String fieldName, String value) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 500,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 60,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          //color: Colors.purple
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      height: 120,
                      // color: Colors.red,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 20, left: 20),
                          child: CustomtextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            controller: controller,
                            hintText: 'Enter $name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: appColorGrey,
                              size: 30.0,
                            ),
                          ))),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 90, right: 90, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Container(
                              width: 70,
                              height: 35,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                ),
                                onPressed: () {
                                  if (controller.text.length > 0) {
                                    FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(globalID)
                                        .update({
                                      fieldName: controller.text
                                    }).then((value) {
                                      setState(() {
                                        if (fieldName == "mobile") {
                                          globalPhone = controller.text;
                                        } else if (fieldName == "gender") {
                                          globalGender = controller.text;
                                        } else if (fieldName == "bday") {
                                          globalBday = controller.text;
                                        }
                                      });
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    Toast.show("Enter text", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
                                },
                                color: buttonColorBlue,
                                textColor: Colors.white,
                                child: Text("Update".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
