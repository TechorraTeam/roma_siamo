import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pressfame_new/constant/global.dart';

class TermsOfServices extends StatefulWidget {

  @override
  State<TermsOfServices> createState() => _TermsOfServicesState();
}

class _TermsOfServicesState extends State<TermsOfServices> { 
  double _fontSize = 16;
  double _headingFontSize = 18;
  final double _baseHeadingFontSize = 18;
  final double _baseFontSize = 16;
  double _fontScale = 1;
  double _baseFontScale = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColorBlack,
        title: Text('terms'.tr,style: TextStyle(fontSize: 18),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: GestureDetector(
           onScaleStart: (ScaleStartDetails scaleStartDetails){
            _baseFontScale = _fontScale;
          },
          onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails){
            setState(() {
              _fontScale = (_baseFontScale * scaleUpdateDetails.scale).clamp(0.5, 5);
              _fontSize = _fontScale * _baseFontSize;
              _headingFontSize = _fontScale * _baseHeadingFontSize;
            });
          },
          child: RichText(
              text: TextSpan(
                children: [
                  customText('terms_detail'.tr+'\n\n'),
                  customHeading('bold_terms'.tr),
                  customHeading('\n\n'+'termination'.tr+'\n\n'),
                  customText('termination_detail'.tr),
                  customHeading('\n\n'+'subscription'.tr+'\n\n'),
                  customText('sub_detail'.tr),
                  customHeading('\n\n'+'content'.tr+'\n\n'),
                  customText('content_detail'.tr),
                  customHeading('\n\n'+'links'.tr+'\n\n'),
                  customText('links_detail'.tr),
                  customHeading('\n\n'+'changes'.tr+'\n\n'),
                  customText('changes_detail'.tr),
                  customHeading('\n\n'+'contact'.tr+'\n\n'),
                  customText('contact_detail'.tr),
                ],
              ),
            )),
        ),
      ),      
    ); 
  }
    customText(text){
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.black,fontSize: _fontSize),    
  );
}

customHeading(text){
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.black,fontSize: _headingFontSize,fontWeight: FontWeight.bold),
  );
}
}