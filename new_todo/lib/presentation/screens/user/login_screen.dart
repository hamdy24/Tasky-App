import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_todo/shared/components/components.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../data/data_sources/cache_helper.dart';
import '../../task_cubit/authentication/authenticationCubit.dart';
import '../../task_cubit/authentication/authentication_state.dart';
import '../../task_cubit/task/taskCubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final thePhoneController = PhoneController(initialValue: PhoneNumber.parse('+20'));
  final _passwordController = TextEditingController();
  String completePhone = '';

  int phoneMinLen = 10;
  int phoneMaxLen = 10;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) => ConditionalBuilder(
            condition: (screenHeight > 900 || screenWidth > 450),
            builder: (context) =>
                LoginLayout_Desktop(screenWidth, screenHeight),
            fallback: (context) =>
                LoginLayout_Mobile(screenWidth, screenHeight)),
      ),
    );
  }

  Widget LoginLayout_Mobile(double screenWidth, double screenHeight) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(children: [
          Image.asset(
            'assets/images/backImage.jpg',
            // height: 482,
            width: screenWidth,
            fit: BoxFit.cover,
          ),
          Container(
            width: screenWidth,
            height: screenHeight-(screenHeight*0.08),
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) => Padding(
                  padding: const EdgeInsets.only(right: 24.5, left: 24.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,bottom: 20),
                        child: Text(
                          'Login',
                          style: GoogleFonts.dmSans(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: screenWidth,
                          // height: 50,
                          child: phoneFormField(context,thePhoneController),
                        ),
                      ),
                      // SizedBox(height: 10),
                      defaultFormField(
                          text: 'Password',
                          validate: emptyFieldEnglish,
                          myController: _passwordController,
                          inputType: TextInputType.visiblePassword,
                          suffix_icon: AuthenticationCubit.isPassVisible
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off,
                          suffix_function: () {
                            AuthenticationCubit.isPassVisible
                                ? AuthenticationCubit.get(context)
                                .passVisibility(false)
                                : AuthenticationCubit.get(context)
                                .passVisibility(true);
                          },
                          myWidth: screenWidth * 0.97,
                          myHeight: 60,
                          fontSize: (screenHeight * .009 + screenWidth * .02),
                          iconsSize: (screenHeight * .01 + screenWidth * .03),
                          isEnglish: true,
                          haveBorder: true,
                          isPassField: !AuthenticationCubit.isPassVisible),
                      SizedBox(height: screenHeight / 35),
                      ConditionalBuilder(
                        condition: !AuthenticationCubit.isLoginPressed,
                        fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                        builder: (context) => FittedBox(
                          fit: BoxFit.fitHeight,
                          child: defaultButton(
                            context: context,
                            text: 'Sign In',
                            myWidth: screenWidth,
                            myHeight:50,
                            fontSize: 16,
                            pressFunc: () {
                              if (_formKey.currentState!.validate()) {
                                completePhone = '+${thePhoneController.value.countryCode}${thePhoneController.value.nsn}';
                                /// authentication here
                                AuthenticationCubit.get(context)
                                    .loginWith(
                                  phone: completePhone,
                                  password: _passwordController.text,
                                )
                                    .then(
                                      (value) {
                                    if (AuthenticationCubit.LoginState == 1) {
                                      Navigator.pushNamed(context, '/tasks');
                                      TaskCubit.get(context).loadTasks();
                                      AuthenticationCubit.isProfileEmpty = true;
                                      CacheHelper.storeData(key: 'accessToken', value: AuthenticationCubit.accessToken);
                                    } else if (AuthenticationCubit
                                        .LoginState ==
                                        2) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Invalid Phone or Password',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.01 +
                                                    screenHeight * 0.01,
                                                fontWeight: FontWeight.bold)),
                                        action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              "Didn't have any account? ",
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                "Sign Up here",
                                style: GoogleFonts.dmSans(
                                  fontSize: (screenHeight * .009 +
                                      screenWidth * .010),
                                  color: HexColor('#5F33E1'),
                                  fontWeight: FontWeight.w700,
                                  textStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }


  Padding LoginLayout_Desktop(double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,bottom: 20),
                      child: Text(
                        'Login',
                        style: GoogleFonts.dmSans(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.5,
                      child: phoneFormField(context,thePhoneController)
                    ),

                    const SizedBox(height: 10),
                    defaultFormField(
                      text: 'Password',
                      validate: emptyFieldEnglish,
                      myController: _passwordController,
                      suffix_icon: AuthenticationCubit.isPassVisible
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off,
                      suffix_function: () {
                        AuthenticationCubit.isPassVisible
                            ? AuthenticationCubit.get(context)
                                .passVisibility(false)
                            : AuthenticationCubit.get(context)
                                .passVisibility(true);
                      },
                      myWidth: screenWidth * 0.5,
                      myHeight: 80,
                      fontSize: (screenHeight * .009 + screenWidth * .008),
                      iconsSize: (screenHeight * .01 + screenWidth * .01),
                      isEnglish: true,
                      isPassField: !AuthenticationCubit.isPassVisible,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ConditionalBuilder(
                      condition: !AuthenticationCubit.isLoginPressed,
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      builder: (context) => FittedBox(
                        fit: BoxFit.fitHeight,
                        child: defaultButton(
                          context: context,
                          text: 'Sign In',
                          myWidth: screenWidth * 0.5,
                          myHeight: 46,
                          fontSize: 16,
                          pressFunc: () {
                            if (_formKey.currentState!.validate()) {
                              completePhone = '+${thePhoneController.value.countryCode}${thePhoneController.value.nsn}';
                              /// authentication here
                              AuthenticationCubit.get(context)
                                  .loginWith(
                                phone: completePhone,
                                password: _passwordController.text,
                              )
                                  .then(
                                (value) {
                                  if (AuthenticationCubit.LoginState == 1) {
                                    Navigator.pushNamed(context, '/tasks');
                                    TaskCubit.get(context).loadTasks();
                                    AuthenticationCubit.isProfileEmpty = true;
                                  } else if (AuthenticationCubit.LoginState ==
                                      2) {}
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: screenWidth*0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              "Didn't have any account? ",
                              style: GoogleFonts.dmSans(
                                fontSize:
                                    (screenHeight * .009 + screenWidth * .009),
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                "Sign Up here",
                                style: GoogleFonts.dmSans(
                                  fontSize:
                                      (screenHeight * .009 + screenWidth * .009),
                                  color: HexColor('#5F33E1'),
                                  fontWeight: FontWeight.w700,
                                  textStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    FittedBox(
                        child: Image.asset(
                      'assets/images/backback.png',
                      width: screenWidth * 0.39,
                      height: screenHeight,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
