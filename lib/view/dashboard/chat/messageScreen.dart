import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/View%20Model/smallProviders.dart';
import 'package:firebasesocialmediaapp/view/dashboard/User/userlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // This callback will be called after the widget is rendered on screen
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  final emojiController = TextEditingController();

  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('Chatroom/${widget.roomId}/chats');

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
              reverse: true,
              scrollDirection: Axis.vertical,
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                if (SessionController().userID ==
                    snapshot.child('Sender').value.toString()) {
                  return _greenMessage(
                      size,
                      snapshot.child('Sender').value.toString(),
                      snapshot.child('message').value.toString());
                } else {
                  return _blueMessage(
                      size,
                      snapshot.child('Sender').value.toString(),
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
          ChangeNotifierProvider(
              create: (_) => SmallProviders(),
              child: Consumer<SmallProviders>(builder: (context, value, child) {
                if (value.setemoji()) {
                  return SizedBox(
                    height: size.height * .35,
                    child: EmojiPicker(
                      textEditingController: emojiController,
                      config: Config(
                          columns: 7,
                          emojiSizeMax: Platform.isIOS ? 1.30 : 1.0),
                    ),
                  );
                }
                
              }))
        ],
      ),
    );
  }

  sendMessage() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Chatroom');

    if (messageController.text.isEmpty) {
      Utils.toastmessage('Enter Something');
    } else {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      ref.child('${widget.roomId}/chats/$timestamp').set({
        'isSeen': false,
        'message': messageController.text.toString(),
        'Sender': SessionController().userID.toString(),
        'reciever': widget.recieverId,
        'type': 'text',
        'time': timestamp.toString()
      }).then((value) {
        messageController.clear();
      }).onError((error, stackTrace) {
        Utils.toastmessage(error.toString());
      });
    }
  }

  Widget _blueMessage(Size size, String senderID, String message) {
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
          child: const Text(
            '22:22',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage(Size size, String senderID, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //for adding some space
            SizedBox(width: size.width * .04),

            //double tick blue icon for message read
            // if (widget.message.read.isNotEmpty)
            //   const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            const Text(
              '22:22',
              // MyDateUtil.getFormattedTime(
              //     context: context, time: widget.message.sent),
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
                  //emoji button
                  ChangeNotifierProvider(
                      create: (_) => SmallProviders(),
                      child: Consumer<SmallProviders>(
                        builder: (context, value, child) {
                          return IconButton(
                            onPressed: () {
                              value.setemoji();
                            },
                            icon: const Icon(Icons.emoji_emotions,
                                color: Colors.blueAccent, size: 25),
                          );
                        },
                      )),

                  Expanded(
                      child: SingleChildScrollView(
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

// bottom chat input field
