import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CreateProfile extends StatefulWidget {
  String userId;
  CreateProfile({this.userId});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<CreateProfile> {
  String orietantion;
  String height;
  String dataheight;

  String gender;
  var gender1 = [
    "Male",
    "Female",
    "Other",
  ];

  final TextEditingController _ageController = TextEditingController();
  FocusNode ageNode = new FocusNode();

  bool isLoading = false;

  var splitData = [];

  String countryValue;
  String stateValue;
  String cityValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: appColorWhite,
            elevation: 1,
            title: Text(
              "create_profile".tr,
              style: TextStyle(
                  fontSize: 17,
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
                  setState(() {
                    ageNode.unfocus();
                  });
                  if (_ageController.text.isNotEmpty &&
                      gender != null &&
                      cityValue != null &&
                      countryValue != null &&
                      stateValue != null &&
                      splitData.length > 0) {
                    updateData();
                  } else {
                    toast("error".tr, "all_fields_mandatory".tr, context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Text(
                    'done'.tr,
                    style: TextStyle(
                        color: appColorBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              ListView(
                children: <Widget>[
                  Container(
                    height: 10,
                  ),
                  editInfoData(),
                ],
              ),
              Center(child: isLoading == true ? loader() : Container())
            ],
          )),
    );
  }

  //EditInfoData >>>>Start

  Widget editInfoData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: 15),
        ageWidget(),
        Container(height: 15),
        genderWidget(),
        Container(height: 15),
        locationWidget(),
        Container(height: 15),
        interestTree(),
        Container(height: 30),
      ],
    );
  }

  Widget ageWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "age".tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: appColorBlack),
          ),
          CustomtextField3(
              textAlign: TextAlign.start,
              controller: _ageController,
              focusNode: ageNode,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintText: 'enter_age'.tr),
        ],
      ),
    );
  }

  Widget genderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "gender".tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: appColorBlack),
          ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      // height: 55,
                      color: Colors.white,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: gender,
                            isDense: true,
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                'select_gender'.tr,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                              ),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: appColorBlack, // Add this
                              ),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                gender = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: gender1.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(
                                  item,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }

  Widget locationWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "location".tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: appColorBlack),
          ),
          Column(
            children: [
              CSCPicker(
                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: appColorWhite,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
                defaultCountry: DefaultCountry.Italy,
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget interestTree() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "what_makes_you_unique".tr,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonWidget("Actor"),
                    buttonWidget("Singer"),
                    buttonWidget("Model"),
                    buttonWidget("Musician"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonWidget("Dancer"),
                    buttonWidget("Artist"),
                    buttonWidget("Filmmaker"),
                    buttonWidget("Writer"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonWidget("Photographer"),
                    buttonWidget("Producer"),
                    buttonWidget("Film Crew"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonWidget("Composer"),
                    buttonWidget("Influencer"),
                    buttonWidget("Hair Stylist"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonWidget("Stylist"),
                    buttonWidget("Animator "),
                    buttonWidget("Editor "),
                    buttonWidget("Present"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonWidget("Creator"),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buttonWidget(title) {
    return splitData.contains(title)
        ? SelectedButton2(
            title: title,
            onPressed: () {
              setState(() {
                splitData.remove(title);
              });
            },
          )
        : UnSelectedButton2(
            title: title,
            onPressed: () {
              setState(() {
                splitData.add(title);
              });
            },
          );
  }

  updateData() {
    var bio = splitData.join(',');
    FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance.collection("user").doc(widget.userId).update({
        'bio': bio,
        'age': _ageController.text,
        'gender': gender,
        'city': cityValue,
        'country': countryValue,
        'state': stateValue,
        'token': token
      }).then((value) {
        if (FirebaseAuth.instance.currentUser != null) {
          dataEntry(widget.userId);
        }
      });
    });
  }

  dataEntry(userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences
        .setString(SharedPreferencesKey.LOGGED_IN_USERRDATA, userId)
        .then((value) {
      setState(() {
        globalID = userId;
        isLoading = false;
      });
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => PagesWidget(),
        ),
      );
      toast("Success", "User Register Success", context);
    });
  }
}
