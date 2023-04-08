import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasesocialmediaapp/View%20Model/Services/sessionManager.dart';
import 'package:firebasesocialmediaapp/view/Posts/add_posts.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../res/color.dart';
import '../Posts/PostScreen.dart';
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
      const PostScreen(),
      const AddPostScreen(),
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
      body: PersistentTabView(
        context,
        screens: _buildScreen(),
        items: _navBarItems(),
        controller: controller,
        backgroundColor: AppColors.otpHintColor,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
