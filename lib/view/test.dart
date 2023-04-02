// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// import '../res/color.dart';
// import 'dashboard/chat/messageScreen.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   DatabaseReference ref = FirebaseDatabase.instance.ref().child('Chatroom');

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FirebaseAnimatedList(
//         query: ref,
//         itemBuilder: (context, snapshot, animation, index) {
//           return Card(
//             child: ListTile(
//               onTap: () {},
//               leading: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: AppColors.primaryButtonColor),
//                   ),
//                   child: snapshot.child('profile').value.toString() == ""
//                       ? const Icon(Icons.person_outline)
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Image(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                   snapshot.child('profile').value.toString())),
//                         )),
//               title: Text(snapshot.child('message').value.toString()),
//               subtitle: Text(snapshot.child('message').value.toString()),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
