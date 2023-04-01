import 'package:firebasesocialmediaapp/View%20Model/ForgotPassword/ForgotPasswordController.dart';
import 'package:firebasesocialmediaapp/res/color.dart';
import 'package:firebasesocialmediaapp/utils/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View Model/login/loginController.dart';
import '../../Widgets/RoundButton.dart';
import '../../Widgets/custom_form_field.dart';
import '../../utils/routes/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  final formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
  }

  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * .01),
                Text("Forgot Password",
                    style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: size.height * .01),
                Text(
                  "Enter your Email Address\nto Recover to your Password",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: size.height * .01),
                Form(
                  key: formkey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * .06),
                    child: Column(
                      children: [
                        CustomFormField(
                          onChanged: (value) {},
                          controller: emailController,
                          onFieldSubmitted: (value) {
                            // Utils.fieldfoucs(
                            //     context, emailFocusNode, passwordFocusNode);
                          },
                          enabledBorderColor: Colors.grey,
                          focusNode: emailFocusNode,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                ChangeNotifierProvider(
                  create: (_) => ForgotPasswordController(),
                  child: Consumer<ForgotPasswordController>(
                    builder: (context, provider, child) {
                      return RoundButton(
                        loading: provider.loading,
                        onpress: () {
                          if (formkey.currentState!.validate()) {
                            provider.forgotPassword(
                                emailController.text, context);
                          }
                        },
                        title: "Recover",
                        buttonColor: AppColors.primaryButtonColor,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont have an Account"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routename.signUp);
                      },
                      child: Text(
                        "Sign Up",
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
          ),
        ),
      ),
    );
  }
}
