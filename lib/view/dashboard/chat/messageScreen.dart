import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:flutter/material.dart';
import '../../../res/color.dart';
import '../../../utils/routes/route_name.dart';
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
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Chatroom');

  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, Routename.userListScreen);
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
              query: ref.child('${widget.roomId}'),
              itemBuilder: (context, snapshot, animation, index) {
                return message(size, snapshot.child('Sender').value.toString(),
                    snapshot.child('message').value.toString());
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  onChanged: (value) {},
                  cursorColor: AppColors.primaryTextTextColor,
                  onFieldSubmitted: (value) {},
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(
                        onTap: () {
                          sendMessage();
                        },
                        child: const CircleAvatar(
                          backgroundColor: AppColors.primaryButtonColor,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ),
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter Message',
                    errorStyle: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                          color: AppColors.textFieldDefaultFocus, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                          color: AppColors.secondaryColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                          color: AppColors.textFieldDefaultBorderColor,
                          width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                          color: AppColors.alertColor, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                          color: AppColors.alertColor, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isEmpty) {
      Utils.toastmessage('Send Message');
    } else {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      ref.child(widget.roomId + '/chats').set({
        // => Error here
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

  Widget message(Size size, String senderID, String message) {
    return Container(
      width: size.width,
      alignment: SessionController().userID == senderID
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: SessionController().userID == senderID
                ? Colors.blue
                : Colors.green,
          ),
          child: Text(message, style: const TextStyle(color: Colors.white))),
    );
  }
}
