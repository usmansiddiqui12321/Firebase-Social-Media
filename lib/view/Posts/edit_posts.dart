import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../View Model/Posts/postsController.dart';
import '../../Widgets/RoundButton.dart';
import '../../Widgets/custom_form_field.dart';
import 'PostScreen.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key, required this.title, required this.id});

  final String title, id;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // EditPost.editPostController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Posts"),
          centerTitle: true,
        leading: IconButton(onPressed: (){
           Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PostScreen(),
          ));
        } , icon: const Icon(Icons.arrow_back),),
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
                      controller: provider.editPostController =
                          TextEditingController(text: widget.title),
                      onChanged: (value) {},
                      // initialvalue: widget.title,
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
                            provider.editPost(widget.id, context);
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
        ));
  }
}
