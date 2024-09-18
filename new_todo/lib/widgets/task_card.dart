import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../shared/components/components.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ConditionalBuilder(
        condition: (screenHeight>900 || screenWidth >450),
        builder: (context) => cardItemLayoutDesktop(context, screenHeight,screenWidth),
        fallback: (context) => cardItemLayoutMobile(context, screenHeight,screenWidth)
    );
  }

  Container cardItemLayoutMobile(BuildContext context, double screenHeight, double screenWidth) {

    String dateFormatted = convertDateFormat(task.dueDate.split('T')[0].split(' ')[0]);

    return Container(
        child:
        defaultTaskBuilder(
            onTabFunc:  () {
              Navigator.pushNamed(
                context,
                '/task-detail',
                arguments: task,
              );
            },
            onOptionsFunc: (){},
            id: task.id,
            imgUrl: task.path,
            title: task.title,
            taskStatus: task.status,
            description: task.description,
            priority: task.priority,
            dueDate: dateFormatted ,
            context: context,
            myHeight: screenHeight*0.18,
            myWidth: screenWidth*0.95,
            fontSize: (screenWidth*0.03+screenHeight*0.01)-4,
            isDesktop: false,
            connectionState: false
        )

    );
  }

  Container cardItemLayoutDesktop(BuildContext context, double screenHeight, double screenWidth) {
    String dateFormatted = convertDateFormat(task.dueDate.split('T')[0].split(' ')[0]);

    return Container(
        child:
        defaultTaskBuilder(
            onTabFunc:  () {
              Navigator.pushNamed(
                context,
                '/task-detail',
                arguments: task,
              );
            },
            onOptionsFunc: (){},
            id: task.id,
            imgUrl: task.path,
            title: task.title,
            taskStatus: task.status,
            description: task.description,
            priority: task.priority,
            dueDate: dateFormatted,
            context: context,
            myHeight: screenHeight*0.18,
            myWidth: screenWidth*0.95,
            fontSize: (screenWidth*0.01+screenHeight*0.01),
            isDesktop: true,
            connectionState: false
        )

    );
  }

}
