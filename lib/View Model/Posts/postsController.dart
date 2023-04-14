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
  final searchController = TextEditingController();
  TextEditingController editPostController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _isLike = false;
  bool get isLike => _isLike;

  final picker = ImagePicker();
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  File? _image;
  File? get image => _image;
  final databaseRef = FirebaseDatabase.instance.ref(); // use the root reference
  final fetchref = FirebaseDatabase.instance.ref('Posts');
  DatabaseReference ref = FirebaseDatabase.instance.ref('User');
  DatabaseReference userref =
      FirebaseDatabase.instance.ref('User/${SessionController().userID}');

  final postID = DateTime.now().millisecondsSinceEpoch.toString();

  //Add Post

  setLike(String postId) async {
    fetchref.child(postId).update({'likes': isLike ? 'like' : 'unlike'});
    _isLike = !_isLike;
    notifyListeners();
  }

  Future<void> addPost(BuildContext context) async {
    DatabaseEvent user = await userref.once();

    // create a unique ID for post

    // add post data
    databaseRef.child('Posts/$postID').set({
      "title": postController.value.text.toString(),
      "id": postID,
      "postedBy": user.snapshot.child('userName').value.toString(),
      'profile': user.snapshot.child('profile').value.toString(),
      'postImage': '',
      'userID': SessionController().userID,
      'likes': 'unlike', // initial likes count
    }).then((_) {
      Utils.toastmessage("Post Added");
      postController.text = "";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(),
        ),
      );
      setLoading(false);

      SessionController().userName = ref.child("userName").once().toString();
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
      setLoading(false);
    });
  }

  // To add Comments
  Future<void> addComment(String postId, String commentText) async {
    DatabaseEvent user = await userref.once();
    final commentId = DateTime.now().millisecondsSinceEpoch.toString();

    databaseRef.child('Posts/$postId/comments/$commentId').set({
      "comment": commentText,
      "commentId": commentId,
      "userCommentId": SessionController().userID.toString(),
      "commentedBy": user.snapshot.child('userName').value.toString(),
      'profile': user.snapshot.child('profile').value.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((_) {
      Utils.toastmessage("Comment added");
      // commentController.text = "";
      setLoading(false);
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
      setLoading(false);
    });
  }

  Future<void> editPost(String id, BuildContext context) async {
    fetchref.child(id).update({'title': editPostController.text}).then((value) {
      Utils.toastmessage("Post Updated");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PostScreen(),
          ));

      postController.text = '';
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
    });
  }

  Future<void> editComment(BuildContext context, String postID,
      String commentid, TextEditingController commentController) async {
    final databaseRef = FirebaseDatabase.instance.ref('Posts/$postID/comments');
    databaseRef
        .child(commentid)
        .update({'comment': commentController.text.toString()}).then((value) {
      Utils.toastmessage("Comment Updated");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PostScreen(),
          ));

      // postController.text = ''; Yad sy empty krna h
    }).onError((error, stackTrace) {
      Utils.toastmessage(error.toString());
    });
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // ignore: use_build_context_synchronously
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // ignore: use_build_context_synchronously

      notifyListeners();
    }
  }

  void pickPostImage(context) {
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

  void uploadPostImage(BuildContext context) async {
    setLoading(true);
    fs.Reference storageref = fs.FirebaseStorage.instance
        .ref('/Posts/PostImage$postID${SessionController().userID}');
    fs.UploadTask uploadTask = storageref.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newUrl = await storageref.getDownloadURL();
    fetchref
        .child(postID)
        .update({'postImage': newUrl.toString()})
        .then((value) => {
              Utils.toastmessage('Post Added'),
              setLoading(false),
              _image = null,
            })
        .onError((error, stackTrace) {
          setLoading(false);

          return Utils.toastmessage(error.toString());
        });
  }
}
