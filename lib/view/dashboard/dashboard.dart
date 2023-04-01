import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/dashboard/chat/messageScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../res/color.dart';
import '../../utils/routes/route_name.dart';
import 'Profile/Profile.dart';
import 'User/userlistscreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _DashboardState extends State<Dashboard> {
  final controller = PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreen() {
    return [
      const Text("Home"),
      const MessageScreen(email: "", image: "", name: "", recieverId: ""),
      const Text("Add"),
      const UserListScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeColorPrimary: AppColors.primaryIconColor,
          inactiveColorPrimary: AppColors.textFieldDefaultBorderColor),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat),
          activeColorPrimary: AppColors.primaryIconColor,
          inactiveColorPrimary: AppColors.textFieldDefaultBorderColor),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.add, color: AppColors.whiteColor),
          activeColorPrimary: AppColors.primaryIconColor,
          inactiveColorPrimary: AppColors.textFieldDefaultBorderColor),
      PersistentBottomNavBarItem(
          activeColorPrimary: AppColors.primaryIconColor,
          icon: const Icon(Icons.message_outlined),
          inactiveColorPrimary: AppColors.textFieldDefaultBorderColor),
      PersistentBottomNavBarItem(
          activeColorPrimary: AppColors.primaryIconColor,
          icon: const Icon(Icons.person),
          inactiveColorPrimary: AppColors.textFieldDefaultBorderColor),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) => {
                      SessionController().userID = '',
                      Navigator.pushNamed(context, Routename.loginScreen)
                    });
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text("Welcome"),
      ),
      body: PersistentTabView(
        context,
        screens: _buildScreen(),
        items: _navBarItems(),
        controller: controller,
        backgroundColor: AppColors.otpHintColor,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }
}