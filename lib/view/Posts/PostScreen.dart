import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/Posts/add_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../View Model/Posts/postsController.dart';
import '../../Widgets/custom_form_field.dart';
import '../../res/color.dart';
import 'comments.dart';
import 'edit_posts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the top of the list after the list has been built
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  final postsref = FirebaseDatabase.instance.ref('Posts').orderByChild('id');
  final ScrollController _scrollController = ScrollController();
  final userref =
      FirebaseDatabase.instance.ref('User/${SessionController().userID}');
  // final bool isLike = false;
  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        child: Icon(
          Icons.add,
          color: isDarkMode ? Colors.black : Colors.white,
        ),
      ),
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
                      controller: _scrollController,
                      defaultChild:
                          const Center(child: CircularProgressIndicator()),
                      itemBuilder: ((context, snapshot, animation, index) {
                        final title = snapshot.child('title').value.toString();
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profilepic),
                                      ),
                                      title: Text(
                                        postedby,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '1 hr',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      trailing: snapshot
                                                  .child('userID')
                                                  .value
                                                  .toString() ==
                                              SessionController()
                                                  .userID
                                                  .toString()
                                          ? PopupMenuButton(
                                              icon: const Icon(Icons.more_vert),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.edit),
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
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 2,
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.delete),
                                                      title:
                                                          const Text("Delete"),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        ref.fetchref
                                                            .child(
                                                              snapshot
                                                                  .child('id')
                                                                  .value
                                                                  .toString(),
                                                            )
                                                            .remove();
                                                      },
                                                    ),
                                                  ),
                                                ];
                                              },
                                            )
                                          : null,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                                                  CircularProgressIndicator(),
                                            );
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
                                            child: CircularProgressIndicator(),
                                          )
                                        ],
                                      );
                                    }
                                  })(),
                                ),
                                //Like and Comment
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black)),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          ref.setLike(snapshot
                                              .child('id')
                                              .value
                                              .toString());
                                        },
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 5),
                                            snapshot
                                                        .child('likes')
                                                        .value
                                                        .toString() ==
                                                    'like'
                                                ? const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Colors.black)
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: VerticalDivider(
                                          thickness: .5,
                                          // color: Colors.black,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen: Comments(
                                                    userID: snapshot
                                                        .child('userID')
                                                        .value
                                                        .toString(),
                                                    postID: snapshot
                                                        .child('id')
                                                        .value
                                                        .toString(),
                                                  ),
                                                  withNavBar: false);
                                        },
                                        child: Row(
                                          children: const [
                                            Text("Comments"),
                                            SizedBox(width: 5),
                                            Icon(Icons.mode_comment_outlined)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (postedby // SessionController Name
                            .toLowerCase()
                            .contains(ref.searchController.text
                                .toLowerCase()
                                .toString())) {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(profilepic),
                                      ),
                                      title: Text(
                                        postedby,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '1 hr',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      trailing: snapshot
                                                  .child('userID')
                                                  .value
                                                  .toString() ==
                                              SessionController()
                                                  .userID
                                                  .toString()
                                          ? PopupMenuButton(
                                              icon: const Icon(Icons.more_vert),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.edit),
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
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 2,
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.delete),
                                                      title:
                                                          const Text("Delete"),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        ref.fetchref
                                                            .child(
                                                              snapshot
                                                                  .child('id')
                                                                  .value
                                                                  .toString(),
                                                            )
                                                            .remove();
                                                      },
                                                    ),
                                                  ),
                                                ];
                                              },
                                            )
                                          : null,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                                                  CircularProgressIndicator(),
                                            );
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
                                            child: CircularProgressIndicator(),
                                          )
                                        ],
                                      );
                                    }
                                  })(),
                                ),
                                //Like and Comment
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black)),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          ref.setLike(snapshot
                                              .child('id')
                                              .value
                                              .toString());
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(width: 5),
                                            snapshot
                                                        .child('likes')
                                                        .value
                                                        .toString() ==
                                                    'like'
                                                ? const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Colors.black)
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: VerticalDivider(
                                          thickness: .5,
                                          // color: Colors.black,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen: Comments(
                                                    userID: snapshot
                                                        .child('userID')
                                                        .value
                                                        .toString(),
                                                    postID: snapshot
                                                        .child('id')
                                                        .value
                                                        .toString(),
                                                  ),
                                                  withNavBar: false);
                                        },
                                        child: Row(
                                          children: const [
                                            Text("Comments"),
                                            SizedBox(width: 5),
                                            Icon(Icons.mode_comment_outlined)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
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
        ),
      ),
    );
  }
}
