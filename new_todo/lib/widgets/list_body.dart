import 'package:flutter/material.dart';
import 'package:new_todo/widgets/task_card.dart';

import '../models/task.dart';

class ListBodyScreen extends StatelessWidget{
  final List<Task> tasks;

  const ListBodyScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {

    return  Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(task: tasks[index]);
            },
          ),
        );
  }
}