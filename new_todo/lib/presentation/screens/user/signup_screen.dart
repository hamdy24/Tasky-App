import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../domain/models/user.dart';
import '../../../shared/components/components.dart';
import '../../task_cubit/authentication/authenticationCubit.dart';
import '../../task_cubit/authentication/authentication_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final thePhoneController = PhoneController(initialValue: PhoneNumber.parse('+20'));
  final _experienceController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  String level = 'fresh';

  String completePhone = '';

  int phoneMinLen = 10;
  int phoneMaxLen = 10;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
          condition: (screenHeight > 900 || screenWidth > 550),
          builder: (context) =>
              signUpLayoutDesktop(screenHeight, screenWidth, context),
          fallback: (context) =>
              signUpLayoutMobile(screenHeight, screenWidth, context),
        ),
      ),
    );
  }

  Widget signUpLayoutMobile(
      double screenHeight, double screenWidth, BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [

          Image.asset(
            'assets/images/signupback.jpg',
            height: 310,
            width: screenWidth-25,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight-70,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.5, left: 24.5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Login',
                            style: GoogleFonts.dmSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        defaultFormField(
                            text: 'Name...',
                            validate: emptyFieldEnglish,
                            myController: _nameController,
                            myWidth: screenWidth,
                            // myHeight: screenHeight*0.07,
                            fontSize: (screenHeight*.01+screenWidth*.018),
                            iconsSize:(screenHeight*.01+screenWidth*.02),
                            isEnglish: true,
                            haveBorder: true),
                        const SizedBox(
                          height: 15,
                        ),
                        //phone
                        SizedBox(
                          child: phoneFormField(context,thePhoneController),
                        ),


                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            text: 'Years of experience...',
                            validate: emptyFieldEnglish,
                            myController: _experienceController,
                            myWidth: screenWidth,
                            // myHeight: screenHeight*0.07,
                            fontSize: (screenHeight*.01+screenWidth*.018),
                            iconsSize:(screenHeight*.01+screenWidth*.02),
                            isEnglish: true,
                            haveBorder: true),
                        const SizedBox(
                          height: 15,
                        ),
                        /// level

                        defaultDropDownMenu(
                          list: ['fresh', 'junior', 'midLevel', 'senior'],
                          hint: 'Choose experience Level',
                          dropdownValue: '',
                          onChanged: (level){
                            setState(() {
                              this.level = level!;
                            });
                          },
                          // myHeight: screenHeight*0.07,
                          myWidth: screenWidth,
                          myFontSize: screenHeight*0.01+screenWidth*0.018,
                          myBackColor: Colors.white,
                          myTextColor: Colors.deepPurple,
                          hintColor: Colors.black
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            text: 'Address...',
                            validate: emptyFieldEnglish,
                            myController: _addressController,
                            myWidth: screenWidth,
                            // myHeight: screenHeight*0.07,
                            fontSize: (screenHeight*.01+screenWidth*.018),
                            iconsSize:(screenHeight*.01+screenWidth*.02),
                            isEnglish: true,
                            haveBorder: true),
                        const SizedBox(height: 15),
                        defaultFormField(
                            text: 'Password...',
                            validate: emptyFieldEnglish,
                            myController: _passwordController,
                            // prefixIcon: Icons.lock_outline,
                            suffix_icon: AuthenticationCubit.isPassVisible
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off,
                            suffix_function: () {
                              AuthenticationCubit.isPassVisible
                                  ? AuthenticationCubit.get(context).passVisibility(false)
                                  : AuthenticationCubit.get(context).passVisibility(true);
                            },
                            myWidth: screenWidth,
                            // myHeight: screenHeight*0.07,
                            fontSize: (screenHeight*.01+screenWidth*.018),
                            iconsSize:(screenHeight*.01+screenWidth*.02),
                            isEnglish: true,
                            isPassField: !AuthenticationCubit.isPassVisible),
                        const SizedBox(height: 15),
                        ConditionalBuilder(
                          condition: !AuthenticationCubit.isLoginPressed,
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          builder: (context) => defaultButton(
                            context: context,
                            text: 'Sign Up',
                            myWidth: screenWidth,
                            myHeight: screenHeight*0.06,
                            fontSize: (screenHeight*.01+screenWidth*.018),
                            pressFunc: () {
                              if (_formKey.currentState!.validate()) {
                                completePhone = '+${thePhoneController.value.countryCode}${thePhoneController.value.nsn}';
                                User newUser = User(
                                    name: _nameController.text,
                                    phone: completePhone,
                                    experienceYears:
                                        int.parse(_experienceController.text),
                                    address: _addressController.text,
                                    password: _passwordController.text,
                                    level: level);
                                AuthenticationCubit.get(context)
                                    .signUpWith(user: newUser)
                                    .then(
                                  (value) {
                                    if (AuthenticationCubit.SignUpState == 1) {
                                      Navigator.pushNamed(context, '/login');
                                    } else if (AuthenticationCubit.SignUpState == 2) {

                                      final snackBar = SnackBar(
                                        content: Text('Invalid Data, try changing some data',
                                            style: TextStyle(
                                                fontSize:screenHeight*0.01+screenWidth*0.01,
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have any account? ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: (screenHeight*.01+screenWidth*.01),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: (screenHeight*.01+screenWidth*.01),
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                          ),
                ),
              ],
            ),
          ),]
      ),
    );
  }

  Widget signUpLayoutDesktop(
      double screenHeight, double screenWidth, BuildContext context) {
    return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Login',
                        style: GoogleFonts.dmSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    defaultFormField(
                        text: 'Name...',
                        validate: emptyFieldEnglish,
                        myController: _nameController,
                        myWidth: screenWidth*0.5,
                        myHeight: screenHeight*0.07,
                        fontSize: (screenHeight*.01+screenWidth*.01),
                        iconsSize:(screenHeight*.01+screenWidth*.02),
                        isEnglish: true,
                        haveBorder: true),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: screenWidth * 0.5,
                      child: phoneFormField(context,thePhoneController)
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        text: 'Years of experience...',
                        validate: emptyFieldEnglish,
                        myController: _experienceController,
                        myWidth: screenWidth*0.5,
                        myHeight: screenHeight*0.07,
                        fontSize: (screenHeight*.01+screenWidth*.01),
                        iconsSize:(screenHeight*.01+screenWidth*.02),
                        isEnglish: true,
                        haveBorder: true),
                    const SizedBox(
                      height: 10,
                    ),
                    /// level

                    defaultDropDownMenu(
                        list: ['fresh', 'junior', 'midLevel', 'senior'],
                        hint: 'Choose experience level',
                        dropdownValue: '',
                        onChanged: (level){
                          setState(() {
                            this.level = level!;
                          });
                        },
                        myHeight: screenHeight*0.07,
                        myWidth: screenWidth*0.5,
                        myFontSize: screenHeight*0.01+screenWidth*0.01,
                        myBackColor: Colors.white,
                        myTextColor: Colors.deepPurple,
                        hintColor: Colors.black
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        text: 'Address...',
                        validate: emptyFieldEnglish,
                        myController: _addressController,
                        myWidth: screenWidth*0.5,
                        myHeight: screenHeight*0.07,
                        fontSize: (screenHeight*.01+screenWidth*.01),
                        iconsSize:(screenHeight*.01+screenWidth*.02),
                        isEnglish: true,
                        haveBorder: true),
                    const SizedBox(height: 10),
                    defaultFormField(
                        text: 'Password',
                        validate: emptyFieldEnglish,
                        myController: _passwordController,
                        // prefixIcon: Icons.lock_outline,
                        suffix_icon: AuthenticationCubit.isPassVisible
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off,
                        suffix_function: () {
                          AuthenticationCubit.isPassVisible
                              ? AuthenticationCubit.get(context).passVisibility(false)
                              : AuthenticationCubit.get(context).passVisibility(true);
                        },
                        myWidth: screenWidth*0.5,
                        myHeight: screenHeight*0.07,
                        fontSize: (screenHeight*.01+screenWidth*.01),
                        iconsSize:(screenHeight*.01+screenWidth*.01),
                        isEnglish: true,
                        isPassField: !AuthenticationCubit.isPassVisible),
                    const SizedBox(height: 15),
                    ConditionalBuilder(
                      condition: !AuthenticationCubit.isLoginPressed,
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      builder: (context) => defaultButton(
                        context: context,
                        text: 'Sign Up',
                        myWidth: screenWidth*0.5,
                        myHeight: screenHeight*0.06,
                        fontSize: 18,
                        pressFunc: () {
                          completePhone = '+${thePhoneController.value.countryCode}${thePhoneController.value.nsn}';
                          if (_formKey.currentState!.validate()) {
                            User newUser = User(
                                name: _nameController.text,
                                phone: completePhone,
                                experienceYears:
                                int.parse(_experienceController.text),
                                address: _addressController.text,
                                password: _passwordController.text,
                                level: level);
                            AuthenticationCubit.get(context)
                                .signUpWith(user: newUser)
                                .then(
                                  (value) {
                                if (AuthenticationCubit.SignUpState == 1) {
                                  Navigator.pushNamed(context, '/login');
                                } else if (AuthenticationCubit.SignUpState == 2) {

                                  final snackBar = SnackBar(
                                    content: Text('Invalid Data, try changing some data',
                                        style: TextStyle(
                                            fontSize:screenHeight*0.01+screenWidth*0.01,
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: screenWidth*0.1,),
                        Text(
                          "Already have any account? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: (screenHeight*.01+screenWidth*.01),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: (screenHeight*.01+screenWidth*.01),
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Image.asset(
            'assets/images/backback.png',
            height: screenHeight*0.67 ,
            width: screenWidth*0.4,
            fit: BoxFit.cover,
          ),
        ]
    );
  }
}
