import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../View Model/Posts/postsController.dart';
import '../../Widgets/custom_form_field.dart';
import '../../res/color.dart';
import 'edit_posts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final postsref = FirebaseDatabase.instance.ref('Posts');

  final userref =
      FirebaseDatabase.instance.ref('User/${SessionController().userID}');

  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                    // Text(''),
                    Expanded(
                      child: FirebaseAnimatedList(
                        query: postsref,
                        defaultChild:
                            const Center(child: CircularProgressIndicator()),
                        itemBuilder: ((context, snapshot, animation, index) {
                          Stream<DatabaseEvent> stream = userref.onValue;
                          final title =
                              snapshot.child('title').value.toString();
                          final postedby =
                              snapshot.child('postedBy').value.toString();
                          final profilepic =
                              snapshot.child('profile').value.toString();

                          final postpic =
                              snapshot.child('postImage').value.toString();
                          if (ref.searchController.value.text.isEmpty) {
                            return Card(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profilepic),
                                      ),
                                      title: Text(postedby),
                                      subtitle: const Text('1 hr'),
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
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPostScreen(
                                                          title: title,
                                                          id: snapshot
                                                              .child('id')
                                                              .value
                                                              .toString(),
                                                        ),
                                                      ));
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
                                                  ref.fetchref
                                                      .child(snapshot
                                                          .child('id')
                                                          .value
                                                          .toString())
                                                      .remove()
                                                      .then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                    // SizedBox(height: 5),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * .172),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(title)),
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: (() {
                                        if (ref.image == null) {
                                          if (postpic == '') {
                                            return Container();
                                          } else {
                                            return Image(
                                              image: NetworkImage(postpic),
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.error_outline,
                                                  color: AppColors.alertColor,
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          return Stack(
                                            children: [
                                              Image.file(
                                                File(ref.image!.path).absolute,
                                              ),
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            ],
                                          );
                                        }
                                      })(),
                                    ),
                                  ],
                                ));
                          } else if (postedby // SessionController Name
                              .toLowerCase()
                              .contains(ref.searchController.text
                                  .toLowerCase()
                                  .toString())) {
                            return Card(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profilepic),
                                      ),
                                      title: Text(postedby),
                                      subtitle: const Text('1 hr'),
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
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPostScreen(
                                                          title: title,
                                                          id: snapshot
                                                              .child('id')
                                                              .value
                                                              .toString(),
                                                        ),
                                                      ));
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
                                                  ref.fetchref
                                                      .child(snapshot
                                                          .child('id')
                                                          .value
                                                          .toString())
                                                      .remove()
                                                      .then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                    // SizedBox(height: 5),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * .172),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(title)),
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: (() {
                                        if (ref.image == null) {
                                          if (postpic == '') {
                                            return Container();
                                          } else {
                                            return Image(
                                              image: NetworkImage(postpic),
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.error_outline,
                                                  color: AppColors.alertColor,
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          return Stack(
                                            children: [
                                              Image.file(
                                                File(ref.image!.path).absolute,
                                              ),
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            ],
                                          );
                                        }
                                      })(),
                                    ),
                                  ],
                                ));
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
