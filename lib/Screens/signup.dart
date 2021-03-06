import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pressfame_new/Screens/createProfile.dart';
import 'package:pressfame_new/Screens/eula_screen.dart';
import 'package:pressfame_new/Screens/terms_of_services.dart';
import 'package:pressfame_new/constant/global.dart';
import 'dart:io';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File imageFile;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
  }

  String userId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpassController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  Future<void> _register() async {
    try {
      setState(() {
        isLoading = true;
      });
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      ))
          .user;
      if (user != null) {
        dataEntry(user.uid, user.email);
      } else {
        setState(() {
          isLoading = false;
        });
        toast("error".tr, "something_went_wrong".tr, context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      toast("error".tr, e.toString(), context);
    }
  }

  dataEntry(userId, email) async {
    FirebaseFirestore.instance.collection('user').doc(userId).set({
      "name": nameController.text,
      "email": email,
      "mobile": '',
      "userId": userId,
      "img": '',
      "token": '',
      "age": '',
      "gender": '',
      "location": '',
      "bio": '',
      "website": '',
      "status": '',
      "privacy": false,
      "followers": [],
      "following": [],
      "bookmark": [],
      "requested": [],
      "bday": '',
      'city': '',
      'country': '',
      'state': ''
    }, SetOptions(merge: true)).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CreateProfile(userId: userId),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      decoration: BoxDecoration(
        color: Color(0XFF106C6F),
      ),
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                // const Color(0xFFC7A4D5),
                // const Color(0xFFB5B7E0),
                Colors.white,
                Colors.white
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(builder: (context, constraint) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraint.maxHeight),
                          child: IntrinsicHeight(
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 100),
                                    //   child: Center(child: _appIcon()),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: Center(
                                          child: Text(
                                        "Roma Siamo Voi",
                                        style: GoogleFonts.pacifico(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 5,
                                    ),
                                    _nameTextfield(context),
                                    _passwordTextfield(context),
                                    _emailTextfield(context),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 5,
                                    ),
                                    Text(
                                      'by_continuing'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: appColorGrey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: ()=>Get.to(EULAScreen()),
                                          child: Text(
                                            'eula'.tr,
                                             style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w700,
                                                                              ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          'and'.tr,
                                          style: TextStyle(
                                        fontSize: 14,
                                        color: appColorGrey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                        ),
                                        SizedBox(width: 5,),
                                        InkWell(
                                          onTap: ()=>Get.to(TermsOfServices()),
                                          child: Text(
                                            'terms'.tr,
                                            style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w700,
                                                                              ),
                                          ),
                                        ),
                                      ]
                                    ),
                                    //  _mobTextfield(context),
                                    _loginButton(context),
                                  ],
                                ),
                                isLoading == true
                                    ? Center(child: loader())
                                    : Container(),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  _dontHaveAnAccount(context),
                ],
              );
            })),
      ),
    );
  }

  Widget _nameTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          maxLines: 1,
          textInputAction: TextInputAction.next,
          controller: nameController,
          hintText: 'enter_username'.tr,
          prefixIcon: Icon(
            Icons.person,
            color: iconColor,
            size: 30.0,
          ),
        ));
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          textInputAction: TextInputAction.next,
          controller: passwordController,
          maxLines: 1,
          hintText: 'enter_password'.tr,
          obscureText: !_obscureText,
          prefixIcon: Icon(
            Icons.lock,
            color: iconColor,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: appColorGrey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ));
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: CustomtextField(
        maxLines: 1,
        textInputAction: TextInputAction.next,
        controller: emailController,
        hintText: 'enter_email'.tr,
        prefixIcon: Icon(
          Icons.email,
          color: iconColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 0, left: 20),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: CustomButtom(
            title: 'sign_up'.tr,
            color: buttonColorBlue,
            onPressed: () {
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);
              if (passwordController.text != '' &&
                  nameController.text != '' &&
                  // mobileController.text != '' &&
                  regex.hasMatch(emailController.text.trim()) &&
                  emailController.text.trim() != '' &&
                  passwordController.text.length > 5) {
                _register();
              } else {
                simpleAlertBox(
                    content: Text("password_condition".tr), context: context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, top: 10, left: 20, bottom: 10),
        child: Text.rich(
          TextSpan(
            text: "already_have_account".tr,
            style: TextStyle(
              fontSize: 14,
              color: appColorGrey,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'sign_in'.tr,
                style: TextStyle(
                  fontSize: 14,
                  // decoration: TextDecoration.underline,
                  color: fontColorBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
