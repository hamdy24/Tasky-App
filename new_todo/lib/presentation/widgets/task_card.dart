import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import '../../shared/components/components.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String dateFormatted = convertDateFormat(task.dueDate.split('T')[0].split(' ')[0]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = false;
    if((screenHeight>900 || screenWidth >450)){
      isDesktop = false;
    }else{
      isDesktop = true;
    }
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
            fontSize: isDesktop? (screenWidth*0.01+screenHeight*0.01) :(screenWidth*0.03+screenHeight*0.01)-4,
            isDesktop: isDesktop,
            connectionState: false // future usage to check if there is an internet connection at first
        )

    );
  }
}
