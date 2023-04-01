import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/Widgets/RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../View Model/profile/profileController.dart';
import '../../../res/color.dart';
import '../../../utils/routes/route_name.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref('User');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider(
          create: (_) => ProfileController(),
          child: Consumer<ProfileController>(
            builder: (context, provider, child) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: ref
                            .child(SessionController().userID.toString())
                            .onValue,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            Map<dynamic, dynamic> map =
                                snapshot.data.snapshot.value;
                            return Column(
                              children: [
                                SizedBox(height: size.height * .02),
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Center(
                                        child: Container(
                                          height: 130,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: AppColors
                                                      .primaryButtonColor)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: provider.image == null
                                                ? map['profile'].toString() ==
                                                        ''
                                                    ? const Icon(Icons.person,
                                                        size: 50)
                                                    : Image(
                                                        image: NetworkImage(
                                                            map['profile']
                                                                .toString()),
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        },
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                            Icons.error_outline,
                                                            color: AppColors
                                                                .alertColor,
                                                          );
                                                        },
                                                      )
                                                : Stack(
                                                    children: [
                                                      Image.file(
                                                        File(provider
                                                                .image!.path)
                                                            .absolute,
                                                      ),
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        provider.pickImage(context);
                                      },
                                      child: const CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            AppColors.primaryButtonColor,
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: size.height * .03),
                                GestureDetector(
                                  onTap: () {
                                    provider.showUserNameDialogAlert(
                                        context, map['userName'].toString());
                                  },
                                  child: ReusableRow(
                                      title: 'UserName',
                                      value: map['userName'],
                                      iconData: Icons.person_outline),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    provider.showUserPhoneDialogAlert(
                                        context, map['phone'].toString());
                                  },
                                  child: ReusableRow(
                                      title: 'Phone Number',
                                      value: map['phone'] == ''
                                          ? 'xxx-xxx-xxx'
                                          : map['phone'],
                                      iconData: Icons.phone_outlined),
                                ),
                                ReusableRow(
                                    title: 'Email',
                                    value: map['email'],
                                    iconData: Icons.email_outlined),
                              ],
                            );
                          } else {
                            return const Text("Some Error Occured");
                          }
                        },
                      ),
                      SizedBox(height: size.height * .1),
                      RoundButton(
                          onpress: () {
                            auth.signOut().then((value) => {
                                  SessionController().userID = '',
                                  Navigator.pushNamed(
                                      context, Routename.loginScreen)
                                });
                          },
                          title: 'Logout',
                          buttonColor: AppColors.primaryButtonColor)
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class ReusableRow extends StatelessWidget {
  final String value, title;
  final IconData iconData;
  const ReusableRow(
      {super.key,
      required this.value,
      required this.title,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: Theme.of(context).textTheme.titleSmall),
          leading: Icon(
            iconData,
            color: AppColors.primaryIconColor,
          ),
          trailing: Text(value, style: Theme.of(context).textTheme.titleSmall),
        ),
        Divider(color: AppColors.dividedColor.withOpacity(.5)),
      ],
    );
  }
}
