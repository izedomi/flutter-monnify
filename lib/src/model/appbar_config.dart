import 'package:flutter/material.dart';

class AppBarConfig {
  ///Appbar title
  ///Default Monnify
  String? title;

  ///Appbar title color
  ///Default Colors.white
  Color? titleColor;

  ///Appbar title color
  ///Default Colors.white
  Color? backgroundColor;

  ///AppBar leadingIcon
  Widget? leadingIcon;

  AppBarConfig(
      {this.title = "Monnify",
      this.titleColor,
      this.backgroundColor,
      this.leadingIcon});
}
