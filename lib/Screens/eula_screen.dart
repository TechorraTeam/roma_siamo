import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pressfame_new/constant/global.dart';

class EULAScreen extends StatefulWidget {

  @override
  State<EULAScreen> createState() => _EULAScreenState();
}

class _EULAScreenState extends State<EULAScreen> {
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
        title: Text('eula'.tr,style: TextStyle(fontSize: 18),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child:GestureDetector(
          onScaleStart: (ScaleStartDetails scaleStartDetails){
            _baseFontScale = _fontScale;
          },
          onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails){
            setState(() {
              _fontScale = (_baseFontScale * scaleUpdateDetails.scale).clamp(0.5, 5).toDouble();
              _fontSize = _fontScale * _baseFontSize;
              _headingFontSize = _fontScale * _baseHeadingFontSize;
            });
          },
          child:  RichText(
          text: TextSpan(
            children: [
              customHeading('last_updated'.tr + '\n\n'),
              customText("eula_intro".tr),
              customHeading('\n\n' + 'def'.tr + '\n\n'),
              customText('def_intro'.tr),
              customHeading('\n\n' + 'grant_of_license'.tr + '\n\n'),
              customText('grant_detail'.tr),
              customHeading('\n\n' + 'intellectual'.tr + '\n\n'),
              customText('int_detail'.tr),
              customHeading("\n\n" + "description".tr),
              customHeading('\n\n' + 'install'.tr),
              customText('install_detail'.tr),
              customHeading('\n\n' + 'repro'.tr),
              customText('repro_detail'.tr),
              customHeading('\n\n' + 'license'.tr),
              customText("license_detail".tr),
              customHeading('\n\n' + 'update_and_main'.tr + '\n\n'),
              customText("update_detail".tr),
              customHeading('\n\n' + 'support'.tr + '\n\n'),
              customText("support_detail".tr),
              customHeading('\n\n' + 'general_pro'.tr + '\n\n'),
              customHeading('\n\n' + 'termination'.tr + '\n\n'),
              customText("term_detail".tr),
              customHeading('\n\n' + 'notice'.tr + '\n\n'),
              customText("notice_detail".tr),
              customHeading('\n\n' + 'inte'.tr + '\n\n'),
              customText("inte_detail".tr),
              customHeading('\n\n' + 'sever'.tr + '\n\n'),
              customText("sever_detail".tr),
              customHeading('\n\n' + 'warranty'.tr + '\n\n'),
              customText("warranty_detail".tr),
              customHeading('\n\n' + 'lim'.tr + '\n\n'),
              customText("lim_detail".tr),
              customHeading('\n\n' + 'indem'.tr + '\n\n'),
              customText("indem_detail".tr),
              customHeading('\n\n' + 'agreement'.tr + '\n\n'),
              customText("agree_detail".tr),
              customHeading('\n\n' + 'law'.tr + '\n\n'),
              customText("law_detail".tr),
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