import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../View Model/Posts/add_postsController.dart';
import '../../Widgets/custom_form_field.dart';
import 'edit_posts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts Screen"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: WillPopScope(
          onWillPop: () async {
            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt!) >
                    const Duration(seconds: 1)) {
              // show toast message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Press back again to exit"),
                ),
              );
              // save the current time
              _lastPressedAt = DateTime.now();
              return false;
            } else {
              // close the app
              await SystemNavigator.pop();
              return true;
            }
          },
          child: ChangeNotifierProvider(
            create: (_) => PostController(),
            child: Consumer<PostController>(
              builder: (context, ref, child) {
                return SafeArea(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomFormField(
                        onFieldSubmitted: (value) {},
                        controller: ref.searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.text,
                        hint: "Search by User",
                        validator: (value) {},
                        enabledBorderColor: Colors.deepPurple,
                      ),
                    ),
                    Expanded(
                      child: FirebaseAnimatedList(
                        query: ref.fetchref,
                        defaultChild:
                            const Center(child: CircularProgressIndicator()),
                        itemBuilder: ((context, snapshot, animation, index) {
                          final title =
                              snapshot.child('title').value.toString();
                          if (ref.searchController.value.text.isEmpty) {
                            return ListTile(
                              title: Text(title),
                              subtitle:
                                  Text(snapshot.child('id').value.toString()),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text("Edit"),
                                        onTap: () {
                                          Get.back();
                                          Get.to(
                                            EditPostScreen(
                                              title: title,
                                              id: snapshot
                                                  .child('id')
                                                  .value
                                                  .toString(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text("Delete"),
                                        onTap: () {
                                          ref.fetchref
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove()
                                              .then((value) => Get.back());
                                        },
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            );
                          } else if (title.toLowerCase().contains(ref
                              .searchController.text
                              .toLowerCase()
                              .toString())) {
                            return ListTile(
                              title: Text(title),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text("Edit"),
                                        onTap: () {
                                          Get.to(EditPostScreen(
                                            title: title,
                                            id: snapshot
                                                .child('id')
                                                .value
                                                .toString(),
                                          ));
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text("Delete"),
                                        onTap: () {
                                          ref.fetchref
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove()
                                              .then((value) => Get.back());
                                        },
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                      ),
                    ),
                  ]),
                );
              },
            ),
          )),
    );
  }
}
