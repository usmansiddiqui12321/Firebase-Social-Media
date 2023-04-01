import 'package:firebase_database/firebase_database.dart';
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
  final ref = FirebaseDatabase.instance.ref('Chatroom');
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, Routename.dashboard);
          },
        ),
        title: Text(widget.name.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder(
                stream: ref.child('Chatroom').onValue,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return Text(snapshot.data);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextFormField(
                        controller: messageController,
                        onChanged: (value) {},
                        cursorColor: AppColors.primaryTextTextColor,
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: InkWell(
                              onTap: () {
                                sendMessage();
                              },
                              child: const CircleAvatar(
                                backgroundColor: AppColors.primaryButtonColor,
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
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
                                color: AppColors.textFieldDefaultFocus,
                                width: 2),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // SafeArea(
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Expanded(
  //         child: ListView.builder(
  //           itemCount: 100,
  //           itemBuilder: (context, index) {
  //             return Text(index.toString());
  //           },
  //         ),
  //       ),

  //     ],
  //   ),
  // ),
  // bottomNavigationBar: Container(
  //   height: size.height / 10,
  //   width: size.width,
  //   alignment: Alignment.center,
  //   child: Container(
  //     height: size.height / 12,
  //     width: size.width / 1.1,
  //     child: TextFormField(
  //       controller: messageController,
  //       onChanged: (value) {},
  //       cursorColor: AppColors.primaryTextTextColor,
  //       onFieldSubmitted: (value) {},
  //       decoration: InputDecoration(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 15),
  //         suffixIcon: Padding(
  //           padding: const EdgeInsets.only(right: 15.0),
  //           child: InkWell(
  //             onTap: () {
  //               sendMessage();
  //             },
  //             child: const CircleAvatar(
  //               backgroundColor: AppColors.primaryButtonColor,
  //               child: Icon(
  //                 Icons.send,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //         labelStyle: const TextStyle(color: Colors.black),
  //         hintText: 'Enter Message',
  //         errorStyle: const TextStyle(
  //             color: Colors.red, fontWeight: FontWeight.bold),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(50),
  //           borderSide: const BorderSide(
  //               color: AppColors.textFieldDefaultFocus, width: 2),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(50),
  //           borderSide:
  //               const BorderSide(color: AppColors.secondaryColor, width: 2),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(50),
  //           borderSide: const BorderSide(
  //               color: AppColors.textFieldDefaultBorderColor, width: 2),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(50),
  //           borderSide:
  //               const BorderSide(color: AppColors.alertColor, width: 2),
  //         ),
  //         focusedErrorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(50),
  //           borderSide:
  //               const BorderSide(color: AppColors.alertColor, width: 2),
  //         ),
  //       ),
  //     ),
  //   ),
  // ),

  sendMessage() {
    if (messageController.text.isEmpty) {
      Utils.toastmessage('Send Message');
    } else {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      ref.child(timestamp).set({
        'isSeen': false,
        'message': messageController.text.toString(),
        'Sender': SessionController().userID.toString(),
        'reciever': widget.recieverId,
        'type': 'text',
        'time': timestamp.toString()
      }).then((value) {
        messageController.clear();
      });
    }
  }
}
