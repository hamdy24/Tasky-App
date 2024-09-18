import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_todo/shared/cubits/task_cubit/authentication/authentication_state.dart';
import '../../models/user.dart';
import '../../shared/components/components.dart';
import '../../shared/cubits/task_cubit/authentication/authenticationCubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = (screenWidth * 0.02 + screenHeight * 0.01);
    return Scaffold(
      appBar: AppBar(
        // leadingWidth:80,
        titleSpacing: 5,
        leading: IconButton(
          padding: EdgeInsets.only(left: 20),
          icon: SvgPicture.asset(
            'assets/images/Arrow-Left.svg',
            width: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // leadingWidth: screenWidth * 0.1,
        title: Text(
          'Profile',
          style: GoogleFonts.dmSans(
            fontSize:16,
            fontWeight: FontWeight.w700,
            textStyle: const TextStyle(
              fontStyle: FontStyle.normal
            ),
          ),
        ),
      ),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
        if (AuthenticationCubit.isProfileEmpty) {
          AuthenticationCubit.get(context).getUserData();
        }

        return ConditionalBuilder(
            condition: (screenHeight > 900 || screenWidth > 450),
            builder: (context) =>
                profileLayoutDesktop(screenWidth, screenHeight,fontSize),
            fallback: (context) =>
                profileLayoutMobile(screenWidth, screenHeight,fontSize));
      }),
    );
  }

  ConditionalBuilder profileLayoutMobile(
      double screenWidth, double screenHeight,double fontSize) {
    return ConditionalBuilder(
      condition: !AuthenticationCubit.isProfileEmpty,
      builder: (context) {

        final User user = User(
            name: AuthenticationCubit.userName,
            phone: formatPhoneNumber(AuthenticationCubit.userPhone),
            experienceYears: AuthenticationCubit.userYears,
            level: AuthenticationCubit.userLevel,
            address: AuthenticationCubit.userAddress,
            password: 'gg');

        return Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      width: screenWidth*0.95,
                      height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NAME',
                              style:  GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(user.name,
                              style:  GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PHONE',
                                  style: GoogleFonts.dmSans(
                                    fontSize:12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(47, 47, 47, 0.4),
                                    textStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Text(
                                  user.phone,
                                  style: GoogleFonts.dmSans(
                                    fontSize:18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromRGBO(47, 47, 47, 0.6),
                                    textStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              height: screenHeight * .045,
                              child: IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: user.phone))
                                        .then((result) {
                                      final snackBar = SnackBar(
                                        content: Text('Copied to Clipboard',
                                            style: TextStyle(
                                                fontSize:fontSize,
                                                fontWeight: FontWeight.bold)),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  },
                                  icon: SvgPicture.asset('assets/images/copy.svg')
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LEVEL',
                              style: GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(user.level.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('YEARS OF EXPERIENCE',
                              style: GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                            Text('${user.experienceYears} years',
                              style: GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LOCATION',
                              style: GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                            Text(user.address,
                              style: GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
      fallback: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  ConditionalBuilder profileLayoutDesktop(
      double screenWidth, double screenHeight,double fontSize) {
    return ConditionalBuilder(
      condition: !AuthenticationCubit.isProfileEmpty,
      builder: (context) {
        final User user = User(
            name: AuthenticationCubit.userName,
            phone: AuthenticationCubit.userPhone,
            experienceYears: AuthenticationCubit.userYears,
            level: AuthenticationCubit.userLevel,
            address: AuthenticationCubit.userAddress,
            password: 'gg');
        return Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      width: screenWidth*0.95,
                      // height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,top: 6,bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NAME',
                              style:  GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(user.name,
                              style:  GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: screenWidth*0.95,
                      // height: 68,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,top: 6,bottom: 12),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PHONE',
                                  style: GoogleFonts.dmSans(
                                    fontSize:12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(47, 47, 47, 0.4),
                                    textStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Text(formatPhoneNumber(user.phone),
                                  style: GoogleFonts.dmSans(
                                    fontSize:18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromRGBO(47, 47, 47, 0.6),
                                    textStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              child: IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: user.phone))
                                        .then((result) {
                                      final snackBar = SnackBar(
                                        content: Text('Copied to Clipboard',
                                            style: TextStyle(
                                                fontSize:fontSize-8,
                                                fontWeight: FontWeight.bold)),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  },
                                  icon: SvgPicture.asset('assets/images/copy.svg')
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: screenWidth*0.95,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,top: 6,bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LEVEL',
                              style: GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(user.level.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: screenWidth*0.95,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,top: 6,bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('YEARS OF EXPERIENCE',
                              style: GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                            Text('${user.experienceYears} years',
                              style: GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: screenWidth*0.95,
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,top: 6,bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LOCATION',
                              style: GoogleFonts.dmSans(
                                fontSize:12,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(47, 47, 47, 0.4),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                            Text(user.address,
                              style: GoogleFonts.dmSans(
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(47, 47, 47, 0.6),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
      fallback: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  //
  // ConditionalBuilder profileLayoutDesktop(
  //     double screenWidth,
  //     double screenHeight
  // ){
  //   return ConditionalBuilder(
  //     condition: !AuthenticationCubit.isProfileEmpty,
  //     builder: (context) {
  //       final User user = User(
  //           name: AuthenticationCubit.userName,
  //           phone: AuthenticationCubit.userPhone,
  //           experienceYears: AuthenticationCubit.userYears,
  //           level: AuthenticationCubit.userLevel,
  //           address: AuthenticationCubit.userAddress,
  //           password: 'gg');
  //       return Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8),
  //                 child: Container(
  //                   width: screenWidth*0.98,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black12,
  //                         borderRadius: BorderRadius.circular(15)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text('NAME',
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.02 +
  //                                       screenHeight * 0.001),
  //                                   fontWeight: FontWeight.bold)),
  //                           Text(user.name,
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.01 +
  //                                       screenHeight * 0.01),
  //                                   fontWeight: FontWeight.normal)),
  //                         ],
  //                       ),
  //                     )),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black12,
  //                         borderRadius: BorderRadius.circular(15)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Row(
  //                         children: [
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text('PHONE',
  //                                   style: TextStyle(
  //                                       fontSize: (screenWidth * 0.02 +
  //                                           screenHeight * 0.001),
  //                                       fontWeight: FontWeight.bold)),
  //                               Text(user.phone,
  //                                   style: TextStyle(
  //                                       fontSize: (screenWidth * 0.01 +
  //                                           screenHeight * 0.01),
  //                                       fontWeight: FontWeight.normal)),
  //                             ],
  //                           ),
  //                           const Spacer(),
  //                           SizedBox(
  //                             height: screenHeight * .05,
  //                             child: IconButton(
  //                                 onPressed: () {
  //                                   Clipboard.setData(
  //                                           ClipboardData(text: user.phone))
  //                                       .then((result) {
  //                                     final snackBar = SnackBar(
  //                                       content: Text('Copied to Clipboard',
  //                                           style: TextStyle(
  //                                               fontSize: (screenWidth * 0.01 +
  //                                                   screenHeight * 0.001),
  //                                               fontWeight: FontWeight.bold)),
  //                                       action: SnackBarAction(
  //                                         label: 'Undo',
  //                                         onPressed: () {},
  //                                       ),
  //                                     );
  //                                     ScaffoldMessenger.of(context)
  //                                         .showSnackBar(snackBar);
  //                                   });
  //                                 },
  //                                 icon: Icon(
  //                                   Icons.copy,
  //                                   size: screenHeight * 0.015 +
  //                                       screenWidth * 0.015,
  //                                 )),
  //                           )
  //                         ],
  //                       ),
  //                     )),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black12,
  //                         borderRadius: BorderRadius.circular(15)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text('LEVEL',
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.02 +
  //                                       screenHeight * 0.001),
  //                                   fontWeight: FontWeight.bold)),
  //                           Text(user.level.toString(),
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.01 +
  //                                       screenHeight * 0.01),
  //                                   fontWeight: FontWeight.normal)),
  //                         ],
  //                       ),
  //                     )),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black12,
  //                         borderRadius: BorderRadius.circular(15)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text('YEARS OF EXPERIENCE',
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.02 +
  //                                       screenHeight * 0.001),
  //                                   fontWeight: FontWeight.bold)),
  //                           Text('${user.experienceYears} years',
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.01 +
  //                                       screenHeight * 0.01),
  //                                   fontWeight: FontWeight.normal)),
  //                         ],
  //                       ),
  //                     )),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black12,
  //                         borderRadius: BorderRadius.circular(15)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text('LOCATION',
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.02 +
  //                                       screenHeight * 0.001),
  //                                   fontWeight: FontWeight.bold)),
  //                           Text(user.address,
  //                               style: TextStyle(
  //                                   fontSize: (screenWidth * 0.01 +
  //                                       screenHeight * 0.01),
  //                                   fontWeight: FontWeight.normal)),
  //                         ],
  //                       ),
  //                     )),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     fallback: (context) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }
}
