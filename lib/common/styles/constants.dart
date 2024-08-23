import 'package:flutter/material.dart';
class Constants {
  static double superSmall = 8;
  static double superSmallPlus2 = 10;
  static double extraSmall = 12;
  static double small = 14;
  static double smallPlus2 = 16;
  static double medium = 18;
  static double extraMedium = 24;
  static double big = 28;
  static double extraBig = 32;




  //Widgets
  static Widget whiteSpaceHorizontal(double? width){
    return SizedBox(width: width ?? 12,);
  }
  static Widget whiteSpaceVertical(double? height){
    return SizedBox(height: height ?? 12,);
  }
  static Widget wrapInPadding(Widget? child, {double left = 0, double right = 0, double top = 0, double bottom = 0, double? all,}){
    return Padding(
      padding: all == null ? EdgeInsets.fromLTRB(left, top, right, bottom) : EdgeInsets.all(all),
      child: child);
  }
  static Widget wrapInBox(Widget? child, {double? size, Color? color, double? radius, double? innerPadding, double? height, double? width}){
    return Container(
      padding: EdgeInsets.all(innerPadding ?? 0),
      width: width ?? size,
      height: height ?? size,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        
        borderRadius: BorderRadius.circular(radius ?? 12)
      ),
      child: child ?? const SizedBox(width: 12, height: 12,),
    );
  }
}