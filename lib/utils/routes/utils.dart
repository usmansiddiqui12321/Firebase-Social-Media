import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static toastmessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        fontSize: 15,
        textColor: Colors.white,
        timeInSecForIosWeb: 1);
  }

  static void fieldfoucs(
      BuildContext context, FocusNode currentFoucs, FocusNode nextFocus) {
    currentFoucs.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
