import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastConfig {
  /// Duration of toast.
  /// Default Toast.LENGTH_LONG
  Toast? length;

  /// Postion of toast.
  /// Default ToastGravity.BOTTOM
  ToastGravity? position;

  /// Background of toast.
  /// Default Colors.grey
  Color? backgroundColor;

  /// Color of text.
  /// Default Colors.black
  Color? color;

  /// Fontsize of text.
  /// Default 16
  double? fontSize;

  ToastConfig(
      {this.length,
      this.position,
      this.backgroundColor,
      this.color,
      this.fontSize});
}
