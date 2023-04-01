import 'package:firebase_core/firebase_core.dart';
import 'package:firebasesocialmediaapp/res/color.dart';
import 'package:firebasesocialmediaapp/res/fonts.dart';
import 'package:firebasesocialmediaapp/utils/routes/route_name.dart';
import 'package:firebasesocialmediaapp/utils/routes/routes.dart';
import 'package:firebasesocialmediaapp/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          color: Colors.black45,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 40,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          displayMedium: TextStyle(
              fontSize: 32,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          displaySmall: TextStyle(
              fontSize: 28,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.9),
          headlineMedium: TextStyle(
              fontSize: 24,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          headlineSmall: TextStyle(
              fontSize: 20,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          titleLarge: TextStyle(
              fontSize: 17,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w700,
              height: 1.6),
          bodyLarge: TextStyle(
              fontSize: 17,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w700,
              height: 1.6),
          bodyMedium: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.sfProDisplayRegular,
              color: AppColors.primaryTextTextColor,
              height: 1.6),
          bodySmall: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              height: 2.26),
        ),
      ),
      theme: ThemeData(
        primarySwatch: AppColors.primaryMaterialColor,
        scaffoldBackgroundColor: const Color(0xffF5F5F5),
        appBarTheme: const AppBarTheme(
            color: Color(0xffF5F5F5),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 22,
                fontFamily: AppFonts.sfProDisplayMedium,
                color: AppColors.primaryTextTextColor)),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 40,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          displayMedium: TextStyle(
              fontSize: 32,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          displaySmall: TextStyle(
              fontSize: 28,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.9),
          headlineMedium: TextStyle(
              fontSize: 24,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          headlineSmall: TextStyle(
              fontSize: 20,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          titleLarge: TextStyle(
              fontSize: 17,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w700,
              height: 1.6),
          bodyLarge: TextStyle(
              fontSize: 17,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w700,
              height: 1.6),
          bodyMedium: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.sfProDisplayRegular,
              color: AppColors.primaryTextTextColor,
              height: 1.6),
          bodySmall: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              height: 2.26),
        ),
      ),
      home: const SplashScreen(),
      initialRoute: Routename.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
