import 'package:flutter/material.dart';

class ListTileModel{
  Key key;
  String title;
  String subtitle;
  Widget leading;
  Widget trailing;

  ListTileModel({
    this.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

}