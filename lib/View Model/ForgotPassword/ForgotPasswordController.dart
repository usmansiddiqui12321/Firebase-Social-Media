import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasesocialmediaapp/utils/routes/utils.dart';
import 'package:flutter/material.dart';

import '../../../utils/routes/route_name.dart';

class ForgotPasswordController extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void forgotPassword(String email, BuildContext context) async {
    setLoading(true);
    try {
      auth
          .sendPasswordResetEmail(email: email)
          .then((value) => {
                setLoading(false),
                Navigator.pushNamed(context, Routename.loginScreen),
                Utils.toastmessage(
                    "Please Check your Email to recover your Password")
              })
          .onError((error, stackTrace) =>
              {setLoading(false), Utils.toastmessage(error.toString())});
    } catch (e) {
      setLoading(false);

      Utils.toastmessage(e.toString());
    }
  }
}
