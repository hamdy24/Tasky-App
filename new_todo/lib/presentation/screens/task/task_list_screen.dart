import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_todo/shared/components/components.dart';
import '../../../domain/models/task.dart';
import '../../task_cubit/authentication/authenticationCubit.dart';
import '../../task_cubit/task/taskCubit.dart';
import '../../task_cubit/task/task_state.dart';
import '../../widgets/task_card.dart';
import '../user/login_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ConditionalBuilder(
        condition: (screenHeight>900 || screenWidth >450),
        builder: (context) => taskListDesktop(screenWidth, screenHeight, context),
        fallback: (context) => taskListMobile(screenWidth, screenHeight, context)
    );
  }

  Scaffold taskListMobile(double screenWidth, double screenHeight, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Logo',
            style:  GoogleFonts.dmSans(
              fontSize: (screenHeight*.02+screenWidth*.02),
              // color:  Colors.black45,
              fontWeight: FontWeight.bold,
              textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        leadingWidth: screenWidth*0.4,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/profile.svg'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: SvgPicture.asset('assets/images/signout.svg'),
              // Icon(Icons.output_outlined,size: screenHeight*0.02+screenWidth*0.03,),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                //////////////////////////////////////
                AuthenticationCubit.get(context).logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                },), (route) => false,);
              },
            ),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is TaskLoaded || state is TaskAdded || state is TaskDeleted) {
            List<Task> tasks =  [];
            if(TaskCubit.tasksFilter == 'All'){
              tasks.addAll(TaskCubit.taskRepository.tasks);
            }else{
              tasks.addAll(
                  TaskCubit.taskRepository.tasks.where(
                        (element) {
                      return TaskCubit.tasksFilter == element.status;
                    },
                  )
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'My Tasks',
                    style:  GoogleFonts.dmSans(
                      fontSize: (screenWidth*0.02+screenHeight*0.01),
                      color:  Colors.black45,
                      fontWeight: FontWeight.w700,
                      textStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.02,top: screenHeight*0.01,bottom: screenHeight*0.01),
                  child: Container(
                    width: screenWidth,
                    alignment: AlignmentDirectional.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultButton(
                              context: context,
                              text: 'All',
                              radius: 24,
                              myWidth: 50,
                              myHeight: 36,
                              fontSize: 18,
                              selfColor: TaskCubit.tasksFilter == 'All'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: TaskCubit.tasksFilter == 'All'?
                              null:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('All');
                              }
                          ),
                          SizedBox(width: screenWidth * 0.03,),
                          defaultButton(
                              context: context,
                              text: 'InProgress',
                              radius: 24,
                              myWidth: 98,
                              myHeight: 36,
                              fontSize: 18,
                              selfColor: (TaskCubit.tasksFilter == 'InProgress')?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: TaskCubit.tasksFilter == 'InProgress'?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('InProgress');
                              }
                          ),
                          SizedBox(width: screenWidth * 0.03,),
                          defaultButton(
                              context: context,
                              text: 'Waiting',
                              radius: 24,
                              myWidth: 81,
                              myHeight: 36,
                              fontSize: 18,
                              selfColor: TaskCubit.tasksFilter == 'waiting'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: (TaskCubit.tasksFilter == 'waiting'||TaskCubit.tasksFilter == 'Waiting')?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('waiting');

                              }
                          ),
                          SizedBox(width: screenWidth * 0.02,),
                          defaultButton(
                              context: context,
                              text: 'Finished',
                              radius: 24,
                              myWidth: 88,
                              myHeight: 36,
                              fontSize: 19,
                              selfColor: TaskCubit.tasksFilter == 'Finished'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: TaskCubit.tasksFilter == 'Finished'?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('Finished');
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: tasks.isNotEmpty,
                  builder: (context) => Expanded(
                    child: RefreshIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                      onRefresh: () {
                        return Future.sync(() {
                          AuthenticationCubit.get(context).refreshExpiredToken();
                          TaskCubit.get(context).refreshPage();
                          return null;
                        });
                      },notificationPredicate: (ScrollNotification notification) {
                      return notification.depth == 0;
                    },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8),
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return TaskCard(task: tasks[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mood_bad,color: Colors.yellow,size: screenHeight*0.15+screenWidth*0.25,),
                        Text('No Tasks',
                          style: TextStyle(
                            fontSize: (screenWidth+screenHeight)/90,
                          ),),
                        const SizedBox(height: 20,),
                        Text('Add Tasks to enjoy the App',
                          style: TextStyle(
                            fontSize: (screenWidth+screenHeight)/90,
                          ),),
                      ],
                    ),
                  ),
                ),
              ],
            );

          } else  if (state is TaskError) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load tasks',
                  style: TextStyle(
                    fontSize: (screenWidth+screenHeight)/90,
                  ),),
                defaultButton(context: context, text: 'Refresh', pressFunc: (){
                  AuthenticationCubit.get(context).refreshExpiredToken();
                  TaskCubit.get(context).refreshPage();
                })
              ],
            ));
          }
          else{
            print("State is $state ------------- attempting reload tasks");
            TaskCubit.get(context).loadTasks();
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        width: 64,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: 0,
              height: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, '/qr');
              },
              child: Container(
                height: 48,
                width: 48,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: HexColor('#EBE5FF'),
                  child: SvgPicture.asset(
                        'assets/images/qrButton.svg',
                      width: 25,
                      color: HexColor('#5F33E1'),

                    ),
                ),
              ),
            ),
            SizedBox(height: 15),
            MaterialButton(
              minWidth: 0,
              height: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, '/add-task');
              },
              child: Container(
                height:54,
                width: 54,
                child: CircleAvatar(
                  backgroundColor: HexColor('#5F33E1'),
                  radius: 32,
                  child: const Icon(Icons.add,size: 28,color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold taskListDesktop(double screenWidth, double screenHeight, BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: screenWidth*0.05),
          child: Text(
            'Logo',
            style: GoogleFonts.dmSans(
              fontSize: (screenHeight*.02+screenWidth*.02),
              // color:  Colors.black45,
              fontWeight: FontWeight.bold,
              textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        leadingWidth: screenWidth*0.3,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/profile.svg'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child:
            IconButton(
              icon: SvgPicture.asset('assets/images/signout.svg'),
              color: Theme.of(context).primaryColor,
              onPressed: () {
              //////////////////////////////////////
                AuthenticationCubit.get(context).logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                return LoginScreen();
                },), (route) => false,);
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded || state is TaskAdded || state is TaskDeleted) {
            List<Task> tasks =  [];
            if(TaskCubit.tasksFilter == 'All'){
              tasks.addAll(TaskCubit.taskRepository.tasks);
            }else{
              tasks.addAll(
                  TaskCubit.taskRepository.tasks.where(
                        (element) {
                      return TaskCubit.tasksFilter == element.status;
                    },
                  )
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.05),
                  child: Text(
                    'My Tasks',
                    style: GoogleFonts.dmSans(
                      fontSize: (screenHeight*.02+screenWidth*.01),
                      color:  Colors.black45,
                      fontWeight: FontWeight.w500,
                      textStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth*0.02,top: screenHeight*0.01,bottom: screenHeight*0.01),
                      child: Row(
                        children: [
                          defaultButton(
                              context: context,
                              text: 'All',
                              radius: screenWidth*0.02+screenHeight*0.02,
                              myWidth: screenWidth*0.19,
                              myHeight: screenHeight*0.05,
                              fontSize: (screenWidth * 0.01+screenHeight * 0.01),
                              selfColor: TaskCubit.tasksFilter == 'All'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: (TaskCubit.tasksFilter == 'All'||TaskCubit.tasksFilter == 'Waiting')?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('All');
                              }
                          ),
                          SizedBox(width: screenWidth * 0.04,),
                          defaultButton(
                              context: context,
                              text: 'InProgress',
                              radius: screenWidth*0.02+screenHeight*0.01,
                              myWidth: screenWidth*0.24,
                              myHeight: screenHeight*0.05,
                              fontSize: (screenWidth * 0.01+screenHeight * 0.01),
                              selfColor: TaskCubit.tasksFilter == 'InProgress'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: (TaskCubit.tasksFilter == 'InProgress'||TaskCubit.tasksFilter == 'Waiting')?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('InProgress');
                              }
                          ),
                          SizedBox(width: screenWidth * 0.04,),
                          defaultButton(
                              context: context,
                              text: 'Waiting',
                              radius: screenWidth*0.02+screenHeight*0.01,
                              myWidth: screenWidth*0.19,
                              myHeight: screenHeight*0.05,
                              fontSize: (screenWidth * 0.01+screenHeight * 0.01),
                              selfColor: TaskCubit.tasksFilter == 'waiting'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: (TaskCubit.tasksFilter == 'waiting'||TaskCubit.tasksFilter == 'Waiting')?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('waiting');

                              }
                          ),
                          SizedBox(width: screenWidth * 0.025,),
                          defaultButton(
                              context: context,
                              text: 'Finished',
                              radius: screenWidth*0.02+screenHeight*0.01,
                              myWidth: screenWidth*0.21,
                              myHeight: screenHeight*0.05,
                              fontSize: (screenWidth * 0.01+screenHeight * 0.01),
                              selfColor: TaskCubit.tasksFilter == 'Finished'?
                              null:
                              HexColor('#F0ECFF'),
                              contentColor: (TaskCubit.tasksFilter == 'Finished'||TaskCubit.tasksFilter == 'Waiting')?
                              Colors.white:
                              Colors.black45,
                              pressFunc: (){
                                TaskCubit.get(context).filterWith('Finished');
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ConditionalBuilder(
                  condition: tasks.isNotEmpty,
                  builder: (context) => Expanded(
                    child: RefreshIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                      onRefresh: () {
                        return Future.sync(() {
                          AuthenticationCubit.get(context).refreshExpiredToken();
                          TaskCubit.get(context).refreshPage();
                          return null;
                        });
                      },notificationPredicate: (ScrollNotification notification) {
                      return notification.depth == 0;
                    },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0,left: 20),
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return TaskCard(task: tasks[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mood_bad,color: Colors.yellow,size: screenHeight*0.15+screenWidth*0.25,),
                        Text('No Tasks',
                          style: TextStyle(
                            fontSize: (screenWidth+screenHeight)/90,
                          ),),
                        const SizedBox(height: 20,),
                        Text('Add Tasks to enjoy the App',
                          style: TextStyle(
                            fontSize: (screenWidth+screenHeight)/90,
                          ),),
                      ],
                    ),
                  ),
                ),
              ],
            );

          } else  if (state is TaskError) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load tasks',
                  style: TextStyle(
                    fontSize: (screenWidth+screenHeight)/90,
                  ),),
                defaultButton(context: context, text: 'Refresh', pressFunc: (){
                  AuthenticationCubit.get(context).refreshExpiredToken();
                  TaskCubit.get(context).refreshPage();
                })
              ],
            ));
          }
          else{
            print("State is $state ------------- attempting reload tasks");
            TaskCubit.get(context).loadTasks();
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        width: 64,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: 0,
              height: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, '/qr');
              },
              child: Container(
                height: 50,
                width: 50,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: HexColor('#EBE5FF'),
                  child: SvgPicture.asset(
                    'assets/images/qrButton.svg',
                    width: 25,
                    color: HexColor('#5F33E1'),

                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            MaterialButton(
              minWidth: 0,
              height: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, '/add-task');
              },
              child: Container(
                height:64,
                width: 64,
                child: CircleAvatar(
                  backgroundColor: HexColor('#5F33E1'),
                  radius: 32,
                  child: const Icon(Icons.add,size: 28,color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
