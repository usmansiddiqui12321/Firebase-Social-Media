import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View Model/Posts/postsController.dart';
import '../../Widgets/RoundButton.dart';
import '../../Widgets/custom_form_field.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey[700],
          ),
          title: Text(
            'Create Post',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            RoundButton(
              onpress: () {
                Provider.of<PostController>(context, listen: false)
                    .addPost(context)
                    .then((value) =>
                        Provider.of<PostController>(context, listen: false)
                            .uploadPostImage(context));
              },
              title: "Post",
              buttonColor: Colors.transparent,
              textColor: Colors.white,
              width: 60,
              height: 35,
              // size: 16,
              // radius: 20,
              // padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            const SizedBox(width: 10),
          ],
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
                      controller: provider.postController,
                      onChanged: (value) {},
                      hint: "What is in your mind?",
                      keyboardType: TextInputType.text,
                      validator: (value) {},
                      enabledBorderColor: Colors.deepPurple,
                      onFieldSubmitted: (String value) {},
                    ),
                    const SizedBox(height: 25),
                    RoundButton(
                      onpress: () {
                        provider
                            .addPost(context)
                            .then((value) => provider.uploadPostImage(context));
                      },
                      title: "Post",
                      buttonColor: Colors.deepPurple,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    RoundButton(
                        onpress: () {
                          provider.pickPostImage(context);
                        },
                        title: "PickImage"),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
