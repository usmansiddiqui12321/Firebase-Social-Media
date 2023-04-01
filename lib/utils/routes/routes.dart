import 'package:firebasesocialmediaapp/utils/routes/route_name.dart';
import 'package:firebasesocialmediaapp/view/dashboard/dashboard.dart';
import 'package:firebasesocialmediaapp/view/signup/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../../view/ForgotPassword/ForgotPassword.dart';
import '../../view/dashboard/User/userlistscreen.dart';
import '../../view/login/login_screen.dart';
import '../../view/splash/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routename.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routename.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routename.signUp:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case Routename.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case Routename.forgotScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case Routename.userListScreen:
        return MaterialPageRoute(builder: (_) => const UserListScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
