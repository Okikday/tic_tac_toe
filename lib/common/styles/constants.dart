import 'package:flutter/material.dart';
class Constants {

  static double extraSmall = 10;
  static double small = 14;
  static double medium = 18;
  static double extraMedium = 22;
  static double big = 26;
  static double extraBig = 30;


  //Widgets
  static Widget whiteSpaceHorizontal(double? width){
    return SizedBox(width: width ?? 12,);
  }

  static Widget whiteSpaceVertical(double? height){
    return SizedBox(height: height ?? 12,);
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


class MyText {
  
  big(BuildContext context, String? text, {double adjust = 0, Color? color, TextAlign? align, bool? invertColor = false}){
    return Text(text ?? "", style: TextStyle(color: color ?? (invertColor == true ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary), fontSize: Constants.big + adjust, ), textAlign: align ?? TextAlign.start,);
  }

  small(BuildContext context, String? text, {double adjust = 0, Color? color, TextAlign? align, bool? invertColor = false}){
    return Text(text ?? "", style: TextStyle(color: color ?? (invertColor == true ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary), fontSize: Constants.small + adjust, ), textAlign: align ?? TextAlign.start,);
  }

  medium(BuildContext context, String? text, {double adjust = 0, Color? color, TextAlign? align, bool? invertColor = false}){
    return Text(text ?? "", style: TextStyle(color: color ?? (invertColor == true ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary), fontSize: Constants.medium + adjust, ), textAlign: align ?? TextAlign.start,);
  }
}