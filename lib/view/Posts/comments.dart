import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Posts/postsController.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../View Model/Services/sessionManager.dart';
import 'PostScreen.dart';
import 'edit_comment.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key, required this.postID, required this.userID})
      : super(key: key);
  final String postID, userID;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    final commentref = FirebaseDatabase.instance
        .ref()
        .child('Posts/${widget.postID}/comments');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostScreen(),
                  ));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (_) => PostController(),
          child: Consumer<PostController>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Expanded(
                    child: Flexible(
                      child: FirebaseAnimatedList(
                        query: commentref,
                        itemBuilder: (context, snapshot, animation, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12, top: 12, bottom: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey[300],
                              ),
                              child: ListTile(
                                tileColor: Colors.transparent,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .child('profile')
                                      .value
                                      .toString()),
                                ),
                                title: Text(
                                  snapshot
                                      .child('commentedBy')
                                      .value
                                      .toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                    snapshot.child('comment').value.toString()),
                                trailing: widget.userID ==
                                        SessionController().userID.toString()
                                    ? PopupMenuButton(
                                        icon: const Icon(Icons.more_vert),
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              value: 1,
                                              child: ListTile(
                                                leading: const Icon(Icons.edit),
                                                title: const Text("Edit"),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditCommentScreen(
                                                        comment: snapshot
                                                            .child('comment')
                                                            .value
                                                            .toString(),
                                                        commentController:
                                                            commentController,
                                                        commentID: snapshot
                                                            .child('commentId')
                                                            .value
                                                            .toString(),
                                                        postID: widget.postID,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: ListTile(
                                                leading:
                                                    const Icon(Icons.delete),
                                                title: const Text("Delete"),
                                                onTap: () {
                                                  commentref
                                                      .child(
                                                        snapshot
                                                            .child('commentId')
                                                            .value
                                                            .toString(),
                                                      )
                                                      .remove()
                                                      .then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                              ),
                                            ),
                                          ];
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: const TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                focusColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              await provider
                                  .addComment(
                                      widget.postID, commentController.text)
                                  .then((value) => commentController.text = '');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
