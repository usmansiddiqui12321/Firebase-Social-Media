import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../View Model/Posts/postsController.dart';
import '../../Widgets/RoundButton.dart';
import '../../Widgets/custom_form_field.dart';
import 'PostScreen.dart';

class EditCommentScreen extends StatefulWidget {
  const EditCommentScreen(
      {super.key,
      required this.postID,
      required this.commentID,
      required this.commentController,
      required this.comment});
  final String postID, commentID, comment;
  final TextEditingController commentController;
  @override
  State<EditCommentScreen> createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.comment);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Edit Comments"),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => PostController(),
        child: Consumer<PostController>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  CustomFormField(
                    maxlines: 4,
                    controller: _commentController,
                    onChanged: (value) {},
                    hint: "What is in your mind?",
                    keyboardType: TextInputType.text,
                    validator: (value) {},
                    enabledBorderColor: Colors.deepPurple,
                    onFieldSubmitted: (String value) {},
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundButton(
                        onpress: () {
                          Navigator.pop(context);
                        },
                        title: "Cancel",
                        buttonColor: Colors.grey,
                        textColor: Colors.black,
                      ),
                      RoundButton(
                        onpress: () {
                          provider
                              .editComment(
                                context,
                                widget.postID,
                                widget.commentID,
                                _commentController,
                              )
                              .then((value) => _commentController.text = '');
                        },
                        title: "Edit",
                        buttonColor: Colors.deepPurple,
                        textColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
