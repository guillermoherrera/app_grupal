import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class Utilerias{

  Future<bool> checkInternet()async{
    final result = await InternetAddress.lookup('google.com').timeout(Duration(milliseconds: 10000));
    if(!result.isNotEmpty || !result[0].rawAddress.isNotEmpty)
      return false;
    return true;
  }

}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}