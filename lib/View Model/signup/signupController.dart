import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasesocialmediaapp/utils/routes/utils.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/route_name.dart';
import '../Services/sessionManager.dart';

class SignUpController extends ChangeNotifier {
  FocusNode emailFocusNode = FocusNode();

  TextEditingController usernameController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signUp(String username, String email, String password,
      BuildContext context) async {
    setLoading(true);
    try {
      auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => {
                setLoading(false),
                SessionController().userID = value.user!.uid.toString(),
                ref
                    .child(value.user!.uid.toString())
                    .set({
                      'uid': value.user!.uid.toString(),
                      'email': value.user!.email.toString(),
                      'onlineStatus': 'noOne',
                      'profile': '',
                      'phone': '',
                      'userName': username
                    })
                    .then((value) => {
                          setLoading(false),
                          Navigator.pushNamed(context, Routename.dashboard),
                        })
                    .onError((error, stackTrace) => {
                          setLoading(false),
                          Utils.toastmessage(error.toString())
                        }),
                setLoading(false),
                Utils.toastmessage('User Created Successfully')
              })
          .onError((error, stackTrace) =>
              {setLoading(false), Utils.toastmessage(error.toString())});
    } catch (e) {
      setLoading(false);

      Utils.toastmessage(e.toString());
    }
  }
}
