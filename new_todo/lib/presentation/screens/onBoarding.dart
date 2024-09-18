import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_todo/presentation/screens/user/login_screen.dart';
import 'package:new_todo/data/data_sources/cache_helper.dart';

class OnBoarding extends StatelessWidget{
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight*0.01+screenWidth*0.01;

    print('width: $screenWidth');
    print('height: $screenHeight');
    print('font: $fontSize');

    return ConditionalBuilder(
        condition: (screenHeight>900 || screenWidth >450),
        builder: (context) => boardingLayoutDesktop(screenWidth, screenHeight, fontSize, context),
        fallback: (context) => boardingLayoutMobile(screenWidth, screenHeight, fontSize, context)
    );
    return boardingLayoutMobile(screenWidth, screenHeight, fontSize, context);
  }

  Scaffold boardingLayoutMobile(double screenWidth, double screenHeight, double fontSize, BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/backImage.jpg',
                // height: 482,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 482,width: screenWidth,),
                Text('Task Management &',
                  style: GoogleFonts.dmSans(
                      fontSize: 24,
                      color: HexColor('#24252C'),
                      fontWeight: FontWeight.bold
                  )
                ),
                Text('To-Do List',
                  style:  GoogleFonts.dmSans(
                      fontSize: 24,
                      color: HexColor('#24252C'),
                      fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 5,),
                Text('This productive tool is designed to help',
                  style:  GoogleFonts.dmSans(
                      fontSize: 14,
                      color: HexColor('#6E6A7C'),
                      fontWeight: FontWeight.w400
                  )
                ),
                Text('you better manage your task',
                  style:  GoogleFonts.dmSans(
                      fontSize: 14,
                      color: HexColor('#6E6A7C'),
                      fontWeight: FontWeight.w400
                  )
                ),
                Text('project-wise conveniently!',
                  style:  GoogleFonts.dmSans(
                      fontSize: 14,
                      color: HexColor('#6E6A7C'),
                      fontWeight: FontWeight.w400
                  )
                ),
                SizedBox(height: 50,),
                Container(
                  width: screenWidth*0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: HexColor('#5F33E1'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Let\'s Start',
                            style: GoogleFonts.dmSans(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.w700
                            )
                          ),
                          const SizedBox(width: 4,),
                          RotatedBox(
                            quarterTurns: 2,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/Arrow-Left.svg',
                                width: 24,
                                color: Colors.white,

                              ),
                              onPressed: () {
                                CacheHelper.storeData(key: 'isBoarded', value: true);
                                Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ), (route) => false,);
                              },
                            ),
                          ),
                        ],
                      ),
                      onPressed:  (){
                        CacheHelper.storeData(key: 'isBoarded', value: true);
                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ), (route) => false,);
                      }
                  ),
                ),

              ],
            ),]
          ),
        ),
      ),
    );
  }

  Scaffold boardingLayoutDesktop(double screenWidth, double screenHeight, double fontSize, BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
                child: Image.asset(
                  'assets/images/backImage.jpg',
                  width: screenWidth,
                  height: screenHeight*0.6,
                )
            ),
            Text('Task Management &',
              style: TextStyle(
                  fontSize: fontSize+10,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text('To-Do List',
              style: TextStyle(
                  fontSize: fontSize+10,
                  fontWeight: FontWeight.bold
              ),),
            SizedBox(height: 5,),
            Text('This productive tool is designed to help',
              style: TextStyle(
                  fontSize: fontSize+3,
                  fontWeight: FontWeight.w300
              ),),
            Text('you better manage your task',
              style: TextStyle(
                  fontSize: fontSize+3,
                  fontWeight: FontWeight.w300
              ),),
            Text('project-wise conveniently!',
              style: TextStyle(
                  fontSize: fontSize+3,
                  fontWeight: FontWeight.w300
              ),),
            SizedBox(height: 15,),
            Container(
              width: screenWidth*0.8,
              height: screenHeight*0.06,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Let\'s Start',style: TextStyle(color: Colors.white),),
                      const SizedBox(width: 4,),
                      Icon(Icons.arrow_forward_sharp,size: fontSize+12,color: Colors.white,)
                    ],
                  ),
                  onPressed:  (){
                    CacheHelper.storeData(key: 'isBoarded', value: true);
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ), (route) => false,);
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }

}