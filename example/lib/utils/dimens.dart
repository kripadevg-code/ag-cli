import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized dimension constants for consistent spacing, powered by ScreenUtil.
abstract class Dimens {
  static double get two => 2.w;
  static double get four => 4.w;
  static double get six => 6.w;
  static double get eight => 8.w;
  static double get ten => 10.w;
  static double get twelve => 12.w;
  static double get fourteen => 14.w;
  static double get sixTeen => 16.w;
  static double get eighteen => 18.w;
  static double get twenty => 20.w;
  static double get twentyFour => 24.w;
  static double get twentyEight => 28.w;
  static double get thirtyTwo => 32.w;
  static double get fourty => 40.w;

  static EdgeInsets get defaultPadding => EdgeInsets.symmetric(horizontal: sixTeen);
  static EdgeInsets get onlyTop12 => EdgeInsets.only(top: twelve);
  static EdgeInsets get onlyTop16 => EdgeInsets.only(top: sixTeen);
}
