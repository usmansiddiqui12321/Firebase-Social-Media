import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DateTime? _lastPressedAt;

  final controller = PersistentTabController(initialIndex: 0);
  List<Widget> _buildScreen() {
    return [
      const PostScreen(),
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
        child: PersistentTabView(
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
      ),
    );
  }
}
