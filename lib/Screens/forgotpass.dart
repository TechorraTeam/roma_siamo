import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'forgetpass2.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailNode = FocusNode();

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
                Colors.white,
                Colors.white,
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: Center(child: _appIcon()),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 5,
                                    ),
                                    Text(
                                      'Forgot your password?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins-Medium',
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 5,
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.blockSizeVertical * 3,
                                    ),
                                    Text(
                                      'Enter Your registerd email below to receive \n password reset instruction',
                                      style: TextStyle(
                                        color: appColorGrey,
                                        fontFamily: 'Poppins-Medium',
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    _emailTextfield(context),
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

  Widget _appIcon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
        child: Image.asset(
          'assets/images/lock.png',
          height: SizeConfig.safeBlockVertical * 8,
        ),
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          focusNode: emailNode,
          controller: emailController,
          hintText: 'Enter Your Email',
          prefixIcon: Icon(
            Icons.email,
            color: iconColor,
            size: 30.0,
          ),
        ));
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 0, left: 20),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: CustomButtom(
            title: 'Next',
            color: buttonColorBlue,
            onPressed: () {
              if (emailController.text.trim() != "") {
                _signInWithEmailAndPassword();
              } else {
                toast(
                    "Error",
                    "Please, Enter your Email Address for reset your password",
                    context);
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
            text: "Back to Login",
            style: TextStyle(
              fontSize: 14,
              color: appColorGrey,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '',
                style: TextStyle(
                  fontSize: 14,
                  // decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        emailNode.unfocus();
        isLoading = true;
      });
      await _auth
          .sendPasswordResetEmail(
        email: emailController.text.trim(),
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ForgetPass2(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        toast("Error", e.toString(), context);
      });
    }
  }
}
