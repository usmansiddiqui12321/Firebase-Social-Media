import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/route_name.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      SessionController().userID = user.uid.toString();
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, Routename.dashboard);
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, Routename.loginScreen);
      });
    }
  }
}
