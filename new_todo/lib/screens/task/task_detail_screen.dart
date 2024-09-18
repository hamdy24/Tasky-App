import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_todo/shared/cubits/task_cubit/task/task_state.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/task.dart';
import '../../shared/components/components.dart';
import '../../shared/cubits/task_cubit/image/imageCubit.dart';
import '../../shared/cubits/task_cubit/image/image_state.dart';
import '../../shared/cubits/task_cubit/task/taskCubit.dart';
import '../../shared/widgets/dropDownMenu.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {

  var titleController = TextEditingController();
  var descController = TextEditingController();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight*0.01+screenWidth*0.018;

    print('width: $screenWidth');
    print('height: $screenHeight');
    print('font: $fontSize');

    return ConditionalBuilder(
      condition: (screenHeight>900 || screenWidth >450),
      fallback: (context) => taskDetailsMobile(screenHeight,screenWidth,fontSize),
      builder: (context) => taskDetailsDesktop(screenHeight,screenWidth,fontSize),
    );
  }

  BlocBuilder<TaskCubit, TaskState> taskDetailsMobile(
      double screenHeight,
      double screenWidth,
      double fontSize
      ) {
    return BlocBuilder<TaskCubit,TaskState>(
      builder: (context, state) =>  Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Task Details',
              style:  GoogleFonts.dmSans(
                  fontSize: 16,
                  color: HexColor('#24252C'),
                  fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal
              )
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/Arrow-Left.svg',
              width: 24,
            ),
            onPressed: () {
              if(TaskCubit.enableUpdate){
                // popup are you sure?
                // for now save
                TaskCubit.get(context).enableTaskUpdate(false);
              }else{
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: CustomDropdownButton(
                items: [
                  {
                    'title':TaskCubit.enableUpdate?'Save' : 'Edit',
                    'color': HexColor('#00060D'),
                    'onClick': () {
                      if(TaskCubit.enableUpdate){

                        widget.task.title = titleController.text;
                        widget.task.description = descController.text;

                        // update
                        Task newTaskData = Task(
                            title: widget.task.title,
                            description: widget.task.description,
                            dueDate: widget.task.dueDate,
                            priority: widget.task.priority,
                            status: widget.task.status,
                            path: ImageCubit.imgPath!,
                            id: widget.task.id
                        );
                        TaskCubit.get(context).updateTask(task: newTaskData);

                        widget.task.path = ImageCubit.imgPath!;
                        // ImageCubit.imgPath = null;
                        // reset flag
                        TaskCubit.get(context).enableTaskUpdate(false);
                      }else{
                        titleController.text = widget.task.title;
                        descController.text = widget.task.description;
                        ImageCubit.imgPath = widget.task.path;
                        TaskCubit.get(context).enableTaskUpdate(true);
                      }
                    }
                  },
                  {
                    'title': 'Delete',
                    'color': HexColor('#FF7D53'),
                    'onClick': () {
                      print('Delete');
                      TaskCubit.get(context).deleteTask(id: widget.task.id);
                      Navigator.pop(context);
                    }
                  },
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 10.0),
            //   child: PopupMenuButton<String>(
            //     position: PopupMenuPosition.under,
            //     shape: _CustomDropdownShape(),
            //     onSelected: (String result) {
            //       switch (result) {
            //         case 1:
            //
            //           break;
            //         case 2:
            //           break;
            //       }
            //     },
            //     icon: const Icon(Icons.more_vert),
            //     itemBuilder:
            //     //     (BuildContext context) {
            //     //   return List<PopupMenuEntry<int>>.generate(
            //     //     2,
            //     //         (int index) => PopupMenuItem<int>(
            //     //       value: index,
            //     //       child: Column(
            //     //         crossAxisAlignment: CrossAxisAlignment.start,
            //     //         children: [
            //     //           Text(
            //     //             'Edit$index',
            //     //             style: TextStyle(color: Colors.black),
            //     //           ),
            //     //           if (index != 1)
            //     //             Divider() // Divider between items
            //     //         ],
            //     //       ),
            //     //     ),
            //     //   );
            //     // },
            //         (BuildContext context) => <PopupMenuEntry<String>>[
            //       PopupMenuItem<String>(
            //         value: 'edit',
            //         child: ListTile(
            //           // leading: Icon(Icons.edit, color: Colors.black,size: fontSize+4,),
            //           title: Text(TaskCubit.enableUpdate? 'Save': 'Edit',
            //               style:  GoogleFonts.dmSans(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //                 // color: HexColor('#5F33E1')
            //               )
            //           ),
            //         ),
            //       ),
            //
            //       PopupMenuItem<String>(
            //         value: 'delete',
            //         child: ListTile(
            //           // leading: Icon(Icons.delete, color: Colors.red,size: fontSize+4,),
            //           title: Text('Delete',style: GoogleFonts.dmSans(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w500,
            //               color: HexColor('#FF7D53')
            //           )
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  builder: (context) {
                    return BlocBuilder<ImageCubit, ImageState>(
                      builder: (context, state) {
                        if (state is ImageInitial) {
                          ImageCubit.imgPath = widget.task.path;
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialogMsg(context).then((value) {
                                  ImageCubit.openCamera?
                                  ImageCubit.get(context).pickImage(ImageSource.camera)
                                      :
                                  ImageCubit.get(context).pickImage(ImageSource.gallery);
                                },);
                                widget.task.path = ImageCubit.imgPath!;
                              },
                              child: Container(
                                height: screenHeight*0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.network(
                                      'https://todo.iraqsapp.com/images/${ImageCubit.imgPath}'
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (state is ImagePicked) {

                          _pickedImage = state.imageFile; // Directly use the File
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialogMsg(context).then((value) {
                                  ImageCubit.openCamera?
                                  ImageCubit.get(context).pickImage(ImageSource.camera)
                                      :
                                  ImageCubit.get(context).pickImage(ImageSource.gallery);
                                },);
                                widget.task.path = ImageCubit.imgPath!;
                              },
                              child: Container(
                                height: screenHeight*0.3,
                                width: screenWidth*0.95,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Image.network('https://todo.iraqsapp.com/images/${ImageCubit.imgPath}')
                                ),
                              ),
                            ),
                          );
                        } else if (state is ImageError) {
                          return Text('Error: ${state.message}');
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  },
                  fallback: (context) {
                    return SizedBox(
                      width: screenWidth*0.95,
                      height: 225,
                      child: Image.network(
                          'https://todo.iraqsapp.com/images/${widget.task.path}'
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                ConditionalBuilder(
                    condition: TaskCubit.enableUpdate,
                    builder: (context) =>

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task Title',
                              style:  GoogleFonts.dmSans(
                                fontSize:fontSize-2,
                                color: HexColor('#6E6A7C'),
                                fontWeight: FontWeight.w400,
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),),
                            const SizedBox(height: 5,),
                            defaultFormField(
                                text: 'Enter Title here',
                                validate: emptyFieldEnglish,
                                myController: titleController,
                                myWidth: screenWidth*0.95,
                                myHeight: 50,
                                linesNum: 1,
                                fontSize: fontSize,
                                isEnglish: true,
                                haveBorder: true),
                          ],
                        ),
                    fallback: (context) =>  Text(
                        widget.task.title,
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 24
                        )
                    )
                ),
                const SizedBox(height: 15),

                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  builder: (context) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Description',
                            style:  GoogleFonts.dmSans(
                              fontSize:fontSize-2,
                              color: HexColor('#6E6A7C'),
                              fontWeight: FontWeight.w400,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),),
                          const SizedBox(height: 5,),
                          defaultFormField(
                              text: 'Enter Description here',
                              validate: emptyFieldEnglish,
                              myController: descController,
                              myWidth: screenWidth*0.95,
                              myHeight: 85,
                              linesNum: 5,
                              fontSize: fontSize,
                              isEnglish: true,
                              haveBorder: true),
                        ],
                      ),
                  fallback: (context) =>  Text(
                      widget.task.description,
                      style: GoogleFonts.dmSans(
                          fontSize: 14
                      )
                  ),
                ),

                const SizedBox(height: 10,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) =>  Text(
                        'Due Date',
                        style:  GoogleFonts.dmSans(
                          fontSize:fontSize-2,
                          color: HexColor('#6E6A7C'),
                          fontWeight: FontWeight.w400,
                          textStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),
                    ),
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) => const SizedBox(height: 5,),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),),
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor('#F0ECFF'),
                          borderRadius: BorderRadius.circular(15),
                        border: TaskCubit.enableUpdate?Border.all(color: HexColor('#BABABA')):null,
                      ),
                      child: SizedBox(
                        width: screenWidth*0.95,
                        height:55,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 8,right: 5),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: Text('End Date',
                                        style:GoogleFonts.dmSans(
                                            fontSize: 9,
                                            color: HexColor('#6E6A7C')
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: Text(
                                      formatDate(widget.task.dueDate.split('T')[0].split(' ')[0]),
                                      style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          color: HexColor('#24252C')
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              ConditionalBuilder(
                                condition: TaskCubit.enableUpdate,
                                builder: (context) =>  IconButton(
                                    onPressed: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(widget.task.dueDate),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          widget.task.dueDate = pickedDate.toString();
                                        });
                                      }
                                    },
                                    icon:  SvgPicture.asset('assets/images/calendar.svg')
                                ),
                                fallback: (context) =>  IconButton(onPressed: null, icon: SvgPicture.asset('assets/images/calendar.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  fallback: (context) => SizedBox(
                      width: screenWidth*0.95,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('#F0ECFF'),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,right:20,top: 10,bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                  widget.task.status,
                                  style:  GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#5F33E1')
                                  )
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/images/Arrow-Down-2.svg',
                                color: HexColor('#5F33E1'),
                                width: 17,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  builder: (context) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style:  GoogleFonts.dmSans(
                              fontSize:fontSize-2,
                              color: HexColor('#6E6A7C'),
                              fontWeight: FontWeight.w400,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),),
                          const SizedBox(height: 5,),
                          defaultDropDownMenu(
                            list: ['InProgress', 'Finished', 'waiting'],
                            hint: widget.task.status,
                            dropdownValue: '',
                            onChanged: (value) {
                              setState(() {
                                widget.task.status = value!;
                              });
                            },
                            svgPath: 'assets/images/Arrow-Down-2.svg',
                            svgSize: 20,
                            myHeight: screenHeight*0.08,
                            myWidth: screenWidth*0.95,
                            myFontSize: fontSize+4,
                            myBackColor: HexColor('#F0ECFF'),
                            myTextColor: HexColor('#5F33E1'),
                          ),
                        ],
                      ),

                ),
                const SizedBox(height: 10),

                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  fallback: (context) => SizedBox(
                      width: screenWidth*0.95,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: HexColor('#F0ECFF'),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,right:20,top: 10,bottom: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/flag.svg',
                                color:HexColor('#5F33E1'),
                                width: 20,
                              ),
                              Text(
                                  (widget.task.priority == 'heigh' || widget.task.priority == 'Heigh'||widget.task.priority == 'high' || widget.task.priority == 'High')
                                      ?' High Priority'
                                      :(widget.task.priority == 'Medium'||widget.task.priority == 'medium')?
                                  ' Medium Priority':' Low Priority',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#5F33E1')
                                  )
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/images/Arrow-Down-2.svg',
                                color: HexColor('#5F33E1'),
                                width: 17,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),

                  builder: (context) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority',
                            style:  GoogleFonts.dmSans(
                              fontSize:fontSize-2,
                              color: HexColor('#6E6A7C'),
                              fontWeight: FontWeight.w400,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),),
                          const SizedBox(height: 5,),
                          defaultDropDownMenu(
                            list: ['high', 'medium', 'low'],
                            hint: widget.task.priority,
                            dropdownValue: '',
                            onChanged: (value) {
                              setState(() {
                                widget.task.priority = value!;
                              });
                            },
                            svgPath: 'assets/images/Arrow-Down-2.svg',
                            svgSize: 20,
                            myHeight: screenHeight*0.08,
                            myWidth: screenWidth*0.95,
                            myFontSize: fontSize+4,
                            myBackColor: HexColor('#F0ECFF'),
                            myTextColor: HexColor('#5F33E1'),
                          ),
                        ],
                      ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SizedBox(
                    height: 326,
                    child: QrImageView(
                      data: widget.task.id,
                      version: QrVersions.auto,
                      size: screenWidth*0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder<TaskCubit, TaskState> taskDetailsDesktop(
      double screenHeight,
      double screenWidth,
      double fontSize
      ) {
    return BlocBuilder<TaskCubit,TaskState>(
      builder: (context, state) =>  Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('Task Details',
              style:  GoogleFonts.dmSans(
                  fontSize: 16,
                  color: HexColor('#24252C'),
                  fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal
              )
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/Arrow-Left.svg',
              width: 24,
            ),
            onPressed: () {
              if(TaskCubit.enableUpdate){
                // popup are you sure?
                // for now save
                TaskCubit.get(context).enableTaskUpdate(false);
              }else{
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: CustomDropdownButton(
                items: [
                  {
                    'title':TaskCubit.enableUpdate?'Save' : 'Edit',
                    'color': HexColor('#00060D'),
                    'onClick': () {
                      if(TaskCubit.enableUpdate){

                        widget.task.title = titleController.text;
                        widget.task.description = descController.text;

                        // update
                        Task newTaskData = Task(
                            title: widget.task.title,
                            description: widget.task.description,
                            dueDate: widget.task.dueDate,
                            priority: widget.task.priority,
                            status: widget.task.status,
                            path: ImageCubit.imgPath!,
                            id: widget.task.id
                        );
                        TaskCubit.get(context).updateTask(task: newTaskData);

                        widget.task.path = ImageCubit.imgPath!;
                        // ImageCubit.imgPath = null;
                        // reset flag
                        TaskCubit.get(context).enableTaskUpdate(false);
                      }else{
                        titleController.text = widget.task.title;
                        descController.text = widget.task.description;
                        ImageCubit.imgPath = widget.task.path;
                        TaskCubit.get(context).enableTaskUpdate(true);
                      }
                    }
                  },
                  {
                    'title': 'Delete',
                    'color': HexColor('#FF7D53'),
                    'onClick': () {
                      print('Delete');
                      TaskCubit.get(context).deleteTask(id: widget.task.id);
                      Navigator.pop(context);
                    }
                  },
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 10.0),
            //   child: PopupMenuButton<String>(
            //     position: PopupMenuPosition.under,
            //     shape: _CustomDropdownShape(),
            //     onSelected: (String result) {
            //       switch (result) {
            //         case 1:
            //
            //           break;
            //         case 2:
            //           break;
            //       }
            //     },
            //     icon: const Icon(Icons.more_vert),
            //     itemBuilder:
            //     //     (BuildContext context) {
            //     //   return List<PopupMenuEntry<int>>.generate(
            //     //     2,
            //     //         (int index) => PopupMenuItem<int>(
            //     //       value: index,
            //     //       child: Column(
            //     //         crossAxisAlignment: CrossAxisAlignment.start,
            //     //         children: [
            //     //           Text(
            //     //             'Edit$index',
            //     //             style: TextStyle(color: Colors.black),
            //     //           ),
            //     //           if (index != 1)
            //     //             Divider() // Divider between items
            //     //         ],
            //     //       ),
            //     //     ),
            //     //   );
            //     // },
            //         (BuildContext context) => <PopupMenuEntry<String>>[
            //       PopupMenuItem<String>(
            //         value: 'edit',
            //         child: ListTile(
            //           // leading: Icon(Icons.edit, color: Colors.black,size: fontSize+4,),
            //           title: Text(TaskCubit.enableUpdate? 'Save': 'Edit',
            //               style:  GoogleFonts.dmSans(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //                 // color: HexColor('#5F33E1')
            //               )
            //           ),
            //         ),
            //       ),
            //
            //       PopupMenuItem<String>(
            //         value: 'delete',
            //         child: ListTile(
            //           // leading: Icon(Icons.delete, color: Colors.red,size: fontSize+4,),
            //           title: Text('Delete',style: GoogleFonts.dmSans(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w500,
            //               color: HexColor('#FF7D53')
            //           )
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  builder: (context) {
                    return BlocBuilder<ImageCubit, ImageState>(
                      builder: (context, state) {
                        if (state is ImageInitial) {
                          ImageCubit.imgPath = widget.task.path;
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialogMsg(context).then((value) {
                                  ImageCubit.openCamera?
                                  ImageCubit.get(context).pickImage(ImageSource.camera)
                                      :
                                  ImageCubit.get(context).pickImage(ImageSource.gallery);
                                },);
                                widget.task.path = ImageCubit.imgPath!;
                              },
                              child: Container(
                                height: screenHeight*0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Image.network(
                                      'https://todo.iraqsapp.com/images/${ImageCubit.imgPath}'
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (state is ImagePicked) {

                          _pickedImage = state.imageFile; // Directly use the File
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialogMsg(context).then((value) {
                                  ImageCubit.openCamera?
                                  ImageCubit.get(context).pickImage(ImageSource.camera)
                                      :
                                  ImageCubit.get(context).pickImage(ImageSource.gallery);
                                },);
                                widget.task.path = ImageCubit.imgPath!;
                              },
                              child: Container(
                                height: screenHeight*0.3,
                                width: screenWidth*0.95,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Image.network('https://todo.iraqsapp.com/images/${ImageCubit.imgPath}')
                                ),
                              ),
                            ),
                          );
                        } else if (state is ImageError) {
                          return Text('Error: ${state.message}');
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  },
                  fallback: (context) {
                    return SizedBox(
                      width: screenWidth*0.95,
                      height: 225,
                      child: Image.network(
                          'https://todo.iraqsapp.com/images/${widget.task.path}'
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConditionalBuilder(
                    condition: TaskCubit.enableUpdate,
                    builder: (context) =>  Text(
                      'Title',
                      style:  GoogleFonts.dmSans(
                        fontSize:fontSize-2,
                        color: HexColor('#6E6A7C'),
                        fontWeight: FontWeight.w400,
                        textStyle: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),),
                    fallback: (context) => SizedBox(width: 0.1,height: 0.1,),
                  ),
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) => const SizedBox(height: 10,),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),),

                    ConditionalBuilder(
                        condition: TaskCubit.enableUpdate,
                        builder: (context) =>
                            defaultFormField(
                                text: 'Enter Title here',
                                validate: emptyFieldEnglish,
                                myController: titleController,
                                myWidth: screenWidth*0.95,
                                myHeight: 50,
                                linesNum: 1,
                                fontSize: fontSize-2,
                                isEnglish: true,
                                haveBorder: true),
                        fallback: (context) =>  Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  widget.task.title,
                                  style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24
                                  )
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) =>  Text(
                        'Description',
                        style:  GoogleFonts.dmSans(
                          fontSize:fontSize-2,
                          color: HexColor('#6E6A7C'),
                          fontWeight: FontWeight.w400,
                          textStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),
                    ),
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) => const SizedBox(height: 10,),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),),

                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) =>
                          defaultFormField(
                              text: 'Enter Description here',
                              validate: emptyFieldEnglish,
                              myController: descController,
                              myWidth: screenWidth*0.95,
                              myHeight: 70,
                              linesNum: 5,
                              fontSize: fontSize-2,
                              isEnglish: true,
                              haveBorder: true),
                      fallback: (context) =>  Padding(
                        padding: const EdgeInsets.only(left: 10.0,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                widget.task.description,
                                style: GoogleFonts.dmSans(
                                    fontSize: 14
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) =>  Text(
                        'Due Date',
                        style:  GoogleFonts.dmSans(
                          fontSize:fontSize-2,
                          color: HexColor('#6E6A7C'),
                          fontWeight: FontWeight.w400,
                          textStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),
                    ),
                    ConditionalBuilder(
                      condition: TaskCubit.enableUpdate,
                      builder: (context) => const SizedBox(height: 10,),
                      fallback: (context) => SizedBox(width: 0.1,height: 0.1,),),

                    Container(
                      decoration: BoxDecoration(
                          color: HexColor('#F0ECFF'),
                          borderRadius: BorderRadius.circular(15),
                        border: TaskCubit.enableUpdate?Border.all(color: HexColor('#BABABA')):null,
                      ),
                      child: SizedBox(
                        width: screenWidth*0.95,
                        height:55,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,top: 8,right: 8),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text('End Date',
                                        style:GoogleFonts.dmSans(
                                            fontSize: 12,
                                            color: HexColor('#6E6A7C')
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      formatDate(widget.task.dueDate.split('T')[0].split(' ')[0]),
                                      style: GoogleFonts.dmSans(
                                          fontSize: 16,
                                          color: HexColor('#24252C')
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              ConditionalBuilder(
                                condition: TaskCubit.enableUpdate,
                                builder: (context) =>  IconButton(
                                    onPressed: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(widget.task.dueDate),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          widget.task.dueDate = pickedDate.toString();
                                        });
                                      }
                                    },
                                    icon:  SvgPicture.asset('assets/images/calendar.svg')
                                ),
                                fallback: (context) =>  IconButton(onPressed: null, icon: SvgPicture.asset('assets/images/calendar.svg')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  fallback: (context) => SizedBox(
                      width: screenWidth*0.95,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('#F0ECFF'),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,right:20,top: 10,bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                  widget.task.status,
                                  style:  GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#5F33E1')
                                  )
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/images/Arrow-Down-2.svg',
                                color: HexColor('#5F33E1'),
                                width: 17,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  builder: (context) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style:  GoogleFonts.dmSans(
                              fontSize:fontSize-2,
                              color: HexColor('#6E6A7C'),
                              fontWeight: FontWeight.w400,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),),
                          const SizedBox(height: 5,),
                          defaultDropDownMenu(
                            list: ['InProgress', 'Finished', 'waiting'],
                            hint: widget.task.status,
                            dropdownValue: '',
                            onChanged: (value) {
                              setState(() {
                                widget.task.status = value!;
                              });
                            },
                            svgPath: 'assets/images/Arrow-Down-2.svg',
                            svgSize: 20,
                            myHeight: screenHeight*0.08,
                            myWidth: screenWidth*0.95,
                            myFontSize: fontSize+4,
                            myBackColor: HexColor('#F0ECFF'),
                            myTextColor: HexColor('#5F33E1'),
                          ),
                        ],
                      ),

                ),
                const SizedBox(height: 10),

                ConditionalBuilder(
                  condition: TaskCubit.enableUpdate,
                  fallback: (context) => SizedBox(
                      width: screenWidth*0.95,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: HexColor('#F0ECFF'),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,right:20,top: 10,bottom: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/flag.svg',
                                color:HexColor('#5F33E1'),
                                width: 20,
                              ),
                              Text(
                                  (widget.task.priority == 'heigh' || widget.task.priority == 'Heigh'||widget.task.priority == 'high' || widget.task.priority == 'High')
                                      ?' High Priority'
                                      :(widget.task.priority == 'Medium'||widget.task.priority == 'medium')?
                                  ' Medium Priority':' Low Priority',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#5F33E1')
                                  )
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/images/Arrow-Down-2.svg',
                                color: HexColor('#5F33E1'),
                                width: 17,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),

                  builder: (context) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority',
                            style:  GoogleFonts.dmSans(
                              fontSize:fontSize-2,
                              color: HexColor('#6E6A7C'),
                              fontWeight: FontWeight.w400,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),),
                          const SizedBox(height: 5,),
                          defaultDropDownMenu(
                            list: ['high', 'medium', 'low'],
                            hint: widget.task.priority,
                            dropdownValue: '',
                            onChanged: (value) {
                              setState(() {
                                widget.task.priority = value!;
                              });
                            },
                            svgPath: 'assets/images/Arrow-Down-2.svg',
                            svgSize: 20,
                            myHeight: screenHeight*0.08,
                            myWidth: screenWidth*0.95,
                            myFontSize: fontSize+4,
                            myBackColor: HexColor('#F0ECFF'),
                            myTextColor: HexColor('#5F33E1'),
                          ),
                        ],
                      ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 326,
                  child: QrImageView(
                    data: widget.task.id,
                    version: QrVersions.auto,
                    size: screenWidth*0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
