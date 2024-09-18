import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/task.dart';
import '../../shared/components/components.dart';
import '../../shared/cubits/task_cubit/image/imageCubit.dart';
import '../../shared/cubits/task_cubit/image/image_state.dart';
import '../../shared/cubits/task_cubit/task/taskCubit.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _priority = 'medium';
  String? imgPath;
  File? _pickedImage;
  bool isPicked = false;
  @override
  Widget build(BuildContext context) {

    BlocProvider.of<ImageCubit>(context).restImage();


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight*0.01+screenWidth*0.01;
    return ConditionalBuilder(
        condition: (screenHeight>900 || screenWidth >450),
        builder: (context) => addTaskDesktop(context,screenHeight,screenWidth,fontSize),

        fallback: (context) => addTaskMobile(context,screenHeight,screenWidth,fontSize)
    );
  }

  Scaffold addTaskMobile(BuildContext context,double screenHeight, double screenWidth, double fontSize) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Add new task',
          style: GoogleFonts.dmSans(
            fontSize:fontSize+6,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        titleSpacing: 5,

        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
              'assets/images/Arrow-Left.svg',
            width: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(22.5),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ImageCubit, ImageState>(
                  builder: (context, state) {
                    if (state is ImageInitial && !isPicked) {
                      return GestureDetector(
                        onTap: () {
                          showDialogMsg(context).then((value) {
                            ImageCubit.openCamera?
                            ImageCubit.get(context).pickImage(ImageSource.camera).then((value) {
                              if(value==false){

                                final snackBar = SnackBar(
                                  content: const Text('Large Images may NOT be uploaded',
                                      style: TextStyle(
                                          fontSize:14,
                                          fontWeight: FontWeight.bold)),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },)
                            : ImageCubit.get(context).pickImage(ImageSource.gallery).then((value) {
                              if(value==false){

                                final snackBar = SnackBar(
                                  content: const Text('Large Images may NOT be uploaded',
                                      style: TextStyle(
                                          fontSize:14,
                                          fontWeight: FontWeight.bold)),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },);
                          },);
                        },
                        child: SizedBox(
                          width: screenWidth*0.95,
                          height: 56,
                          child: DottedBorder(
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            stackFit: StackFit.expand,
                            dashPattern: const <double>[5, 3],
                            color: HexColor('#5F33E1'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: null,
                                    icon: SvgPicture.asset(
                                        'assets/images/imgButton.svg',
                                      width: 24,
                                    )
                                ),
                                Text(
                                  'Add Img',
                                  style: GoogleFonts.dmSans(
                                    fontSize: fontSize+4,
                                    color: HexColor('#5F33E1')
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (state is ImagePicked) {
                      isPicked = true;
                      _pickedImage = state.imageFile; // Directly use the File
                      return GestureDetector(
                        onTap: () {
                          showDialogMsg(context).then((value) {
                            ImageCubit.openCamera?
                            ImageCubit.get(context).pickImage(ImageSource.camera)
                                :
                            ImageCubit.get(context).pickImage(ImageSource.gallery);
                          },);
                        },
                        child: Container(
                          height: screenHeight*0.3,
                          width: screenWidth*0.95,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (state is ImageError) {
                      return Text('Error: ${state.message}');
                    } else if(isPicked){
                      return GestureDetector(
                        onTap: () {
                          showDialogMsg(context).then((value) {
                            ImageCubit.openCamera?
                            ImageCubit.get(context).pickImage(ImageSource.camera)
                                :
                            ImageCubit.get(context).pickImage(ImageSource.gallery);
                          },);
                        },
                        child: Container(
                          height: screenHeight*0.3,
                          width: screenWidth*0.95,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    else{
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(height: screenHeight*0.021,),
                Text(
                  'Task Title',
                style:  GoogleFonts.dmSans(
                  fontSize:fontSize,
                  color: HexColor('#6E6A7C'),
                  fontWeight: FontWeight.w400,
                  textStyle: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),),
                const SizedBox(height: 8,),

                defaultFormField(
                    text: 'Enter title here',
                    validate: emptyFieldEnglish,
                    myController: _titleController,
                    myWidth: screenWidth*0.95,
                    myHeight: screenHeight*0.07,
                    fontSize: fontSize+4,
                    iconsSize:(screenHeight*.008+screenWidth*.01),
                    isEnglish: true,
                    haveBorder: true,decorationRadius: 10
                ),

                const SizedBox(height: 15,),

                Text(
                  'Task Description',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),

                defaultFormField(
                    text: 'Enter description here',
                    linesNum: 8,
                    validate: emptyFieldEnglish,
                    myController: _descriptionController,
                    myWidth: screenWidth*0.95,
                    myHeight: screenHeight*0.07,
                    fontSize: fontSize+4,
                    iconsSize:(screenHeight*.008+screenWidth*.01),
                    isEnglish: true,
                    haveBorder: true
                ),
                const SizedBox(height: 5,),

                Text(
                  'Priority',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),
                defaultDropDownMenu(
                  list: ['high', 'medium', 'low'],
                  hint: 'Choose Priority Level',
                  dropdownValue: '',
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                  myHeight: screenHeight*0.08,
                  myWidth: screenWidth*0.95,
                  myFontSize: fontSize+4,
                  myBackColor: HexColor('#F0ECFF'),
                  myTextColor: HexColor('#5F33E1'),
                ),
                const SizedBox(height: 5,),

                Text(
                  'Due Date',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),
                defaultDatePicker(
                  myHeight: screenHeight*0.07,
                  myWidth: screenWidth*0.95,
                  myFont: fontSize+4,
                  whenPicked: (){
                    setState(() {
                      //////////////////////////////////////////////////////////////////////////
                      // _dueDate = DateTime(dueDateController.text.substring(0,3) as int);
                    });
                  },
                  myController: dueDateController,
                  initDate: _dueDate,
                  context: context,
                ),
                const SizedBox(height: 20),
                defaultButton(
                  context: context,
                  text: 'Add Task',
                  myWidth: screenWidth*0.95,
                  myHeight: screenHeight*0.06,
                  fontSize: 20,
                  pressFunc: () {
                    if (_formKey.currentState!.validate()) {

                      while(ImageCubit.imgPath == null){

                        showDialogMsg(context).then((value) {
                          ImageCubit.openCamera?
                          ImageCubit.get(context).pickImage(ImageSource.camera)
                              :
                          ImageCubit.get(context).pickImage(ImageSource.gallery);
                        },);
                        Future.delayed(const Duration(milliseconds: 100));
                      }

                      final task = Task(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dueDate: dueDateController.text,
                          priority: _priority,
                          status: 'Waiting',
                          imageFile: _pickedImage,
                          id: '',
                          path: ImageCubit.imgPath!
                      );
                      TaskCubit.get(context).addTask(
                          task: task
                      );
                      Navigator.pop(context);
                    }
                  },

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold addTaskDesktop(BuildContext context,double screenHeight, double screenWidth, double fontSize) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new task',
          style: GoogleFonts.dmSans(
            fontSize:fontSize+6,
            fontWeight: FontWeight.w700,
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/Arrow-Left.svg',
            width: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight*0.01+screenWidth*0.01),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ImageCubit, ImageState>(
                  builder: (context, state) {
                    if (state is ImageInitial && !isPicked) {
                      return GestureDetector(
                        onTap: () {
                          showDialogMsg(context).then((value) {
                            ImageCubit.openCamera?
                            ImageCubit.get(context).pickImage(ImageSource.camera).then((value) {
                              if(value==false){

                                final snackBar = SnackBar(
                                  content: const Text('Large Images may NOT be uploaded',
                                      style: TextStyle(
                                          fontSize:14,
                                          fontWeight: FontWeight.bold)),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },)
                                : ImageCubit.get(context).pickImage(ImageSource.gallery).then((value) {
                              if(value==false){

                                final snackBar = SnackBar(
                                  content: const Text('Large Images may NOT be uploaded',
                                      style: TextStyle(
                                          fontSize:14,
                                          fontWeight: FontWeight.bold)),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },);
                          },);
                        },
                        child: SizedBox(
                          width: screenWidth*0.95,
                          height: 56,
                          child: DottedBorder(
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            stackFit: StackFit.expand,
                            dashPattern: const <double>[5, 3],
                            color: HexColor('#5F33E1'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: null,
                                    icon: SvgPicture.asset(
                                      'assets/images/imgButton.svg',
                                      width: 24,
                                    )
                                ),
                                Text(
                                    'Add Img',
                                    style: GoogleFonts.dmSans(
                                        fontSize: fontSize+4,
                                        color: HexColor('#5F33E1')
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (state is ImagePicked) {
                      isPicked = true;
                      _pickedImage = state.imageFile; // Directly use the File
                      return GestureDetector(
                        onTap: () {
                          showDialogMsg(context).then((value) {
                            ImageCubit.openCamera?
                            ImageCubit.get(context).pickImage(ImageSource.camera)
                                :
                            ImageCubit.get(context).pickImage(ImageSource.gallery);
                          },);
                        },
                        child: Container(
                          height: screenHeight*0.3,
                          width: screenWidth*0.95,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (state is ImageError) {
                      return Text('Error: ${state.message}');
                    } else if(isPicked){
                      return GestureDetector(
                        onTap: () {
                          showDialogMsg(context).then((value) {
                            ImageCubit.openCamera?
                            ImageCubit.get(context).pickImage(ImageSource.camera)
                                :
                            ImageCubit.get(context).pickImage(ImageSource.gallery);
                          },);
                        },
                        child: Container(
                          height: screenHeight*0.3,
                          width: screenWidth*0.95,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    else{
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(height: screenHeight*0.021,),
                Text(
                  'Task Title',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),

                defaultFormField(
                    text: 'Enter title here',
                    validate: emptyFieldEnglish,
                    myController: _titleController,
                    myWidth: screenWidth*0.95,
                    myHeight: screenHeight*0.07,
                    fontSize: fontSize+4,
                    iconsSize:(screenHeight*.008+screenWidth*.01),
                    isEnglish: true,
                    haveBorder: true,decorationRadius: 10
                ),

                const SizedBox(height: 15,),

                Text(
                  'Task Description',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),

                defaultFormField(
                    text: 'Enter description here',
                    linesNum: 8,
                    validate: emptyFieldEnglish,
                    myController: _descriptionController,
                    myWidth: screenWidth*0.95,
                    myHeight: screenHeight*0.07,
                    fontSize: fontSize+4,
                    iconsSize:(screenHeight*.008+screenWidth*.01),
                    isEnglish: true,
                    haveBorder: true,decorationRadius: 10
                ),
                const SizedBox(height: 5,),

                Text(
                  'Priority',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),
                defaultDropDownMenu(
                  list: ['high', 'medium', 'low'],
                  hint: 'Choose Priority Level',
                  dropdownValue: '',
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                  myHeight: screenHeight*0.08,
                  myWidth: screenWidth*0.95,
                  myFontSize: fontSize+4,
                  myBackColor: HexColor('#F0ECFF'),
                  myTextColor: HexColor('#5F33E1'),
                ),
                const SizedBox(height: 5,),

                Text(
                  'Due Date',
                  style:  GoogleFonts.dmSans(
                    fontSize:fontSize,
                    color: HexColor('#6E6A7C'),
                    fontWeight: FontWeight.w400,
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                const SizedBox(height: 8,),
                defaultDatePicker(
                  myHeight: screenHeight*0.07,
                  myWidth: screenWidth*0.95,
                  myFont: fontSize+4,
                  whenPicked: (){
                    setState(() {
                      //////////////////////////////////////////////////////////////////////////
                      // _dueDate = DateTime(dueDateController.text.substring(0,3) as int);
                    });
                  },
                  myController: dueDateController,
                  initDate: _dueDate,
                  context: context,
                ),
                const SizedBox(height: 20),
                defaultButton(
                  context: context,
                  text: 'Add Task',
                  myWidth: screenWidth*0.95,
                  myHeight: screenHeight*0.06,
                  fontSize: 20,
                  pressFunc: () {
                    if (_formKey.currentState!.validate()) {

                      while(ImageCubit.imgPath == null){

                        showDialogMsg(context).then((value) {
                          ImageCubit.openCamera?
                          ImageCubit.get(context).pickImage(ImageSource.camera)
                              :
                          ImageCubit.get(context).pickImage(ImageSource.gallery);
                        },);
                        Future.delayed(const Duration(milliseconds: 100));
                      }

                      final task = Task(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dueDate: dueDateController.text,
                          priority: _priority,
                          status: 'Waiting',
                          imageFile: _pickedImage,
                          id: '',
                          path: ImageCubit.imgPath!
                      );
                      TaskCubit.get(context).addTask(
                          task: task
                      );
                      Navigator.pop(context);
                    }
                  },

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
