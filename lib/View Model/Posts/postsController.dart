import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/Posts/PostScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:image_picker/image_picker.dart';

import '../../res/color.dart';
import '../../utils/routes/utils.dart';

class PostController extends ChangeNotifier {
  final postController = TextEditingController();
  final commentController = TextEditingController();
  final searchController = TextEditingController();
  TextEditingController editPostController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final databaseRef = FirebaseDatabase.instance.ref(); // use the root reference
  final fetchref =
      FirebaseDatabase.instance.ref('User/${SessionController().userID}/Posts');
  DatabaseReference ref = FirebaseDatabase.instance.ref('User');
  DatabaseReference userref =
      FirebaseDatabase.instance.ref('User/${SessionController().userID}');

  Future<void> addPost(BuildContext context) async {
    DatabaseEvent username = await userref.once();
    DatabaseEvent profile = await userref.once();

    final postID = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // create a unique ID for post

    databaseRef.child('User/${SessionController().userID}/Posts/$postID').set({
      "title": postController.value.text.toString(),
      "id": postID,
      "postedBy": username.snapshot.child('userName').value.toString(),
      'profile': username.snapshot.child('profile').value.toString(),
      'postImage': ''

      // add post data
    }).then((_) {
      Utils.toastmessage("Post Added");
      postController.text = "";
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(),
          ));
      setLoading(false);

      SessionController().userName = ref.child("userName").once().toString();
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
      setLoading(false);
    });
  }

  void addComment(String postID) {
    final commentID = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // create a unique ID for comment

    // add comment to the post
    databaseRef.child('Posts/$postID/comments/$commentID').set({
      "CommentData": commentController.value.text.toString(),
      // add comment data
    }).then((_) {
      Utils.toastmessage("Comment Added");
      setLoading(false);
      // loading.value = false;
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
      setLoading(false);
      // loading.value = false;
    });
  }

  Future<void> editPost(String id, BuildContext context) async {
    fetchref.child(id).update({'title': editPostController.text}).then((value) {
      Utils.toastmessage("Post Updated");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(),
          ));

      postController.text = '';
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
    });
  }

  final picker = ImagePicker();
  // DatabaseReference ref = FirebaseDatabase.instance.ref('User');
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
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    setLoading(true);
    fs.Reference storageref = fs.FirebaseStorage.instance
        .ref('/Posts/PostImage$postID${SessionController().userID}');
    fs.UploadTask uploadTask = storageref.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newUrl = await storageref.getDownloadURL();
    fetchref
        .update({'postImage': newUrl.toString()})
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
}
