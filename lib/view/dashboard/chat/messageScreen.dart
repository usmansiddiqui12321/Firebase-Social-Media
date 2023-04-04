import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/dashboard/User/userlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../utils/routes/utils.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.email,
      required this.recieverId,
      required this.roomId});
  final String image, name, email, recieverId, roomId;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent * 1000,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('Chatroom/${widget.roomId}/chats');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 248, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: const UserListScreen(), withNavBar: true);
          },
        ),
        title: Text(widget.name.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              controller: _scrollController,
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                dynamic timeSinceEpoch = snapshot.child('time').value;
                DateTime dateTime =
                    DateTime.fromMillisecondsSinceEpoch(timeSinceEpoch);
                String formattedTime = DateFormat('hh:mm a').format(dateTime);
                if (SessionController().userID ==
                    snapshot.child('Sender').value.toString()) {
                  return _greenMessage(size, formattedTime,
                      snapshot.child('message').value.toString());
                } else {
                  return _blueMessage(size, formattedTime,
                      snapshot.child('message').value.toString());
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _chatInput(size),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  sendMessage() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Chatroom');
    if (messageController.text.isEmpty) {
      Utils.toastmessage('Enter Something');
    } else {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      ref.child('${widget.roomId}/chats/$timestamp').set({
        'isSeen': false,
        'message': messageController.text.toString(),
        'Sender': SessionController().userID.toString(),
        'reciever': widget.recieverId,
        'type': 'text',
        'time': timestamp
      }).then((value) {
        messageController.clear();
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }).onError((error, stackTrace) {
        Utils.toastmessage(error.toString());
      });
    }
  }

  Widget _blueMessage(Size size, String time, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
              padding: EdgeInsets.all(size.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * .04, vertical: size.height * .01),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 245, 255),
                  border: Border.all(color: Colors.lightBlue),
                  //making borders curved
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child:
                  //show text
                  Text(
                message,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              )),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: size.width * .04),
          child: Text(
            time,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage(Size size, String time, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //for adding some space
            SizedBox(width: size.width * .04),


            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              time,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        //message content
        Flexible(
          child: Container(
              padding: EdgeInsets.all(size.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * .04, vertical: size.height * .01),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 218, 255, 176),
                  border: Border.all(color: Colors.lightGreen),
                  //making borders curved
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              child:
                  //show text
                  Text(
                message,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              )),
        ),
      ],
    );
  }

  Widget _chatInput(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * .01, horizontal: size.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      minLines: 1,
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      onTap: () {},
                      decoration: const InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none),
                    ),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),

                  //adding some space
                  SizedBox(width: size.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              sendMessage();
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
