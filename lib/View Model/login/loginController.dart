import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasesocialmediaapp/utils/routes/utils.dart';
import 'package:flutter/material.dart';

import '../../../utils/routes/route_name.dart';
import '../Services/sessionManager.dart';

class LoginController extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void login(String email, String password, BuildContext context) async {
    setLoading(true);
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                SessionController().userID = value.user!.uid.toString(),
                // SessionController().userName = value.user!.displayName.toString(),
                setLoading(false),
                Navigator.pushNamed(context, Routename.dashboard)
              })
          .onError((error, stackTrace) =>
              {setLoading(false), Utils.toastmessage(error.toString())});
    } catch (e) {
      setLoading(false);

      Utils.toastmessage(e.toString());
    }
  }


}
