import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class CustomAdBanner extends StatelessWidget {
  final String adUnitID;
  final double height;
  const CustomAdBanner({Key key, this.adUnitID, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final textColor = currentTheme.textTheme.bodyText1.color;
    final defaultTextTheme = NativeTextStyle(color: textColor);
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20.0),
      child: NativeAdmob(
        adUnitID: adUnitID,
        options: NativeAdmobOptions(
          ratingColor: CustomThemes.accentColor,
          priceTextStyle: defaultTextTheme,
          headlineTextStyle: defaultTextTheme,
          adLabelTextStyle: NativeTextStyle(color: Colors.black),
          advertiserTextStyle: NativeTextStyle(color: textColor.withAlpha(150)),
          bodyTextStyle: defaultTextTheme,
          storeTextStyle: defaultTextTheme,
          callToActionStyle: NativeTextStyle(
            backgroundColor: CustomThemes.accentColor,
          ),
        ),
        numberAds: 1,
        loading: CupertinoActivityIndicator(),
        controller: NativeAdmobController(),
        type: NativeAdmobType.full,
      ),
    );
  }
}
