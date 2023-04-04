import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../Widgets/custom_form_field.dart';
import '../../res/color.dart';
import '../../utils/routes/utils.dart';

class ProfileController extends ChangeNotifier {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final namefocus = FocusNode();
  final phonefocus = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final picker = ImagePicker();
  DatabaseReference ref = FirebaseDatabase.instance.ref('User');
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  File? _image;
  File? get image => _image;

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // ignore: use_build_context_synchronously
      uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // ignore: use_build_context_synchronously
      uploadImage(context);

      notifyListeners();
    }
  }

  void pickImage(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera,
                      color: AppColors.primaryIconColor),
                  title: const Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image,
                      color: AppColors.primaryIconColor),
                  title: const Text("Gallery"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void uploadImage(BuildContext context) async {
    setLoading(true);
    fs.Reference storageref = fs.FirebaseStorage.instance
        .ref('/images/profileImage${SessionController().userID}');
    fs.UploadTask uploadTask = storageref.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newUrl = await storageref.getDownloadURL();
    ref
        .child(SessionController().userID.toString())
        .update({'profile': newUrl.toString()})
        .then((value) => {
              Utils.toastmessage('Profile Updated'),
              setLoading(false),
              _image = null,
            })
        .onError((error, stackTrace) {
          setLoading(false);

          return Utils.toastmessage(error.toString());
        });
  }

  Future<void> showUserNameDialogAlert(BuildContext context, String username) {
    nameController.text = username;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Update Username')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formkey,
                  child: CustomFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      hint: '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        if (value.length < 3) {
                          return 'This field must be at least 3 characters long';
                        }
                        return null; // Return null if validation passes
                      },
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {}),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.alertColor))),
            TextButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    ref.child(SessionController().userID.toString()).update({
                      'userName': nameController.text.toString()
                    }).then((value) => {nameController.clear()});
                    Navigator.pop(context);
                  }
                },
                child:
                    Text("Ok", style: Theme.of(context).textTheme.titleSmall!))
          ],
        );
      },
    );
  }

  Future<void> showUserPhoneDialogAlert(
      BuildContext context, String phonenumber) {
    phoneController.text = phonenumber;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Update Username')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formkey,
                  child: CustomFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      hint: '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        if (value.length < 10) {
                          return 'This field must be at least 3 characters long';
                        }
                        return null; // Return null if validation passes
                      },
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {}),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.alertColor))),
            TextButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    ref.child(SessionController().userID.toString()).update({
                      'phone': phoneController.text.toString()
                    }).then((value) => {phoneController.clear()});
                    Navigator.pop(context);
                  }
                },
                child:
                    Text("Ok", style: Theme.of(context).textTheme.titleSmall!))
          ],
        );
      },
    );
  }

  void logout(BuildContext context) {
    try {
      setLoading(true);
      auth.signOut().then((value) {
        SessionController().userID = '';
        SessionController().userName = '';
        setLoading(false);

        PersistentNavBarNavigator.pushNewScreen(context,
            screen: LoginPage(), withNavBar: false);
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.toastmessage(error.toString());
      });
    } catch (e) {
      setLoading(false);

      Utils.toastmessage(e.toString());
    }
  }
}
