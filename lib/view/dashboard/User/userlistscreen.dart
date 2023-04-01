import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/dashboard/chat/messageScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../res/color.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("User List")),
        body: SafeArea(
          child: FirebaseAnimatedList(
            query: ref,
            itemBuilder: (context, snapshot, animation, index) {
              if (SessionController().userID.toString() ==
                  snapshot.child('uid').value.toString()) {
                return Container();
              } else {
                return Card(
                  child: ListTile(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: MessageScreen(
                            email: snapshot.child('email').value.toString(),
                            image: snapshot.child('profile').value.toString(),
                            name: snapshot.child('userName').value.toString(),
                            recieverId: snapshot.child('uid').value.toString(),
                          ),
                          withNavBar: false);
                    },
                    leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.primaryButtonColor),
                        ),
                        child: snapshot.child('profile').value.toString() == ""
                            ? const Icon(Icons.person_outline)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(snapshot
                                        .child('profile')
                                        .value
                                        .toString())),
                              )),
                    title: Text(snapshot.child('userName').value.toString()),
                    subtitle: Text(snapshot.child('email').value.toString()),
                  ),
                );
              }
            },
          ),
        ));
  }
}
