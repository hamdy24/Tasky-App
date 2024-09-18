import 'dart:convert';
import 'dart:io';

import '../models/task.dart';
import 'package:http/http.dart' as http;

import '../shared/cubits/task_cubit/authentication/authenticationCubit.dart';

class TaskRepository {

  static const String baseUrl = 'https://todo.iraqsapp.com/todos';


  List<Task> tasks = [];
  late Task singleTask ;

  final List<String> tasksImages = [  ];


  Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl?page=1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);
      tasks.clear();

      for(int i = 0 ; i<decodedResponse.length ; i++){
        Task newTask = Task(
          id: decodedResponse[i]['_id'],
          path: decodedResponse[i]['image'],
          description: decodedResponse[i]['desc'],
          dueDate: decodedResponse[i]['createdAt'],
          priority: decodedResponse[i]['priority'],
          status: decodedResponse[i]['status'],
          title: decodedResponse[i]['title'],
        );
        tasks.add(
            newTask
        );
      }

      print('--------------- Tasks Fetched ----------------');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to get Tasks');
    }
    return tasks;
  }

  Future<List<Task>> fetchSingleTask(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);


        singleTask = Task(
          id: decodedResponse['_id'],
          path: decodedResponse['image'],
          title: decodedResponse['title'],
          description: decodedResponse['desc'],
          priority: decodedResponse['priority'],
          status: decodedResponse['status'],
          dueDate: decodedResponse['createdAt'],
        );


      print('--------------- Single Task Fetched ----------------');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to get Tasks');
    }
    return tasks;
  }

  Future<void> addTask(Task task) async {

    final response = await http.post(
        Uri.parse('$baseUrl/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
        },
        body: jsonEncode({
          "image"  : task.path,
          "title" :task.title,
          "desc" : task.description,
          "priority" : task.priority,//low , medium , high
          "dueDate" : task.dueDate.split('T')[0]
        })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);

      Task combinedTaskData = Task(
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          priority: task.priority,
          status: decodedResponse['status'],
          path: decodedResponse['image'],
          id: decodedResponse['_id']
      );
      tasks.add(combinedTaskData);
      print('--------------- Add Task SUCCESS ----------------');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to add task');
    }

  }




  Future<void> updateTask(Task task) async {

    final response = await http.put(
        Uri.parse('$baseUrl/${task.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
        },
        body: jsonEncode({
          "image": task.path,
          "title": task.title,
          "desc": task.description,
          "priority": task.priority,
          "status": task.status,
          "user": AuthenticationCubit.userID
        })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      int index = tasks.indexWhere(
        (element) {
          return element.id == task.id;
        },
      );
      tasks.removeAt(index);
      tasks.add(task);
      print('--------------- Update task SUCCESS ----------------');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to update task');
    }

  }



  Future<void> removeTask(String id) async {

    final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
        },
    );
    if (response.statusCode == 200 ) {
      tasks.removeWhere(
        (element) {
          return element.id == id;
        },
      );

      print(response.body);///////////////////////////
      print('--------------- Delete Task SUCCESS ----------------');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to delete task');
    }
  }




}
