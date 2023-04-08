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
          title: const Text("Add Posts"),
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
                      // loading: addPost.loading.value,
                      onpress: () {
                        // addPost.loading.value = true;
                        provider
                            .addPost(context)
                            .then((value) => provider.uploadPostImage(context));
                      },
                      title: "Post",
                      buttonColor: Colors.deepPurple,
                      textColor: Colors.white,
                    ),
                  const  SizedBox(height: 20),
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
