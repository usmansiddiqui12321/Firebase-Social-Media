import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View Model/Posts/postsController.dart';
import '../../res/color.dart';
import '../../utils/routes/route_name.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.grey[700] : Colors.white,
          elevation: 0,
          iconTheme:
              IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Create Post',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
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
                    TextFormField(
                      minLines: 4,
                      maxLines: 7,
                      controller: provider.postController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.textFieldDefaultFocus, width: 2),
                        ),
                        hintText: 'What is in your mind?',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.textFieldDefaultBorderColor,
                            width: 2,
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                provider.pickPostImage(context);
                              },
                              icon: Icon(Icons.image,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.addPost(context);
                                provider.uploadPostImage(context);
                                Navigator.pushNamed(
                                    context, Routename.dashboard);

                                // provider.addPost(context),
                                // provider
                                //     .addPost(context),
                                //     provider.uploadPostImage(context).then((value) {
                                //   Navigator.pushNamed(
                                //       context, Routename.dashboard);
                                //     }))
                              },
                              icon: Icon(Icons.send,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
