import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasesocialmediaapp/View%20Model/signup/signupController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Widgets/RoundButton.dart';
import '../../Widgets/custom_form_field.dart';
import '../../res/color.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/routes/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DateTime? _lastPressedAt;

  final formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
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
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ChangeNotifierProvider(
              create: (_) => SignUpController(),
              child: Consumer<SignUpController>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * .01),
                        Text("WelCome to my App",
                            style: Theme.of(context).textTheme.displaySmall),
                        SizedBox(height: size.height * .01),
                        Text(
                          "Enter your Email Address\nto Register to your Account",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: size.height * .01),
                        Form(
                          key: formkey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * .06),
                            child: Column(
                              children: [
                                CustomFormField(
                                  onFieldSubmitted: (value) {
                                    Utils.fieldfoucs(
                                        context,
                                        provider.usernameFocusNode,
                                        provider.emailFocusNode);
                                  },
                                  onChanged: (value) {},
                                  controller: provider.usernameController,
                                  enabledBorderColor: Colors.grey,
                                  focusNode: provider.emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  label: "UserName",
                                  hint: "Enter Username",
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Enter UserName'
                                        : null;
                                  },
                                ),
                                SizedBox(height: size.height * .01),
                                CustomFormField(
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    Utils.fieldfoucs(
                                        context,
                                        provider.emailFocusNode,
                                        provider.emailFocusNode);
                                  },
                                  controller: provider.emailController,
                                  enabledBorderColor: Colors.grey,
                                  focusNode: provider.emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  label: "Email",
                                  hint: "Enter Email",
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {
                                    return value.isEmpty ? 'Enter Email' : null;
                                  },
                                ),
                                SizedBox(height: size.height * .01),
                                CustomFormField(
                                  controller: provider.passwordController,
                                  focusNode: provider.passwordFocusNode,
                                  onFieldSubmitted: (value) {},
                                  keyboardType: TextInputType.visiblePassword,
                                  inputAction: TextInputAction.done,
                                  enabledBorderColor: Colors.grey,
                                  isObscure: true,
                                  prefixIcon: Icons.lock_open_rounded,
                                  onChanged: (value) {},
                                  label: "Password",
                                  hint: "Enter Password",
                                  validator: (value) {
                                    return value.isEmpty ? 'Enter Email' : null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .02,
                        ),
                        RoundButton(
                          loading: provider.loading,
                          onpress: () {
                            if (formkey.currentState!.validate()) {
                              provider.signUp(
                                  provider.usernameController.text,
                                  provider.emailController.text,
                                  provider.passwordController.text,
                                  context);
                            }
                          },
                          title: "Login",
                          buttonColor: AppColors.primaryButtonColor,
                        ),
                        SizedBox(
                          height: size.height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an Account"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routename.loginScreen);
                              },
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
