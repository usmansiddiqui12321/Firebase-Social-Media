import 'package:firebase_database/firebase_database.dart';
import 'package:firebasesocialmediaapp/view/Posts/PostScreen.dart';
import 'package:flutter/material.dart';

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
  final fetchref = FirebaseDatabase.instance.ref('Posts');

  void addPost(BuildContext context) {
    final postID = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // create a unique ID for post

    databaseRef.child('Posts/$postID').set({
      "title": postController.value.text.toString(),
      "id": postID
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

  @override
  void notifyListeners() {}
}
