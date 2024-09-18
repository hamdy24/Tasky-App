import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo/repositories/image_repository.dart';
import '../../../../models/task.dart';
import '../../../../repositories/task_repository.dart';
import '../../../../widgets/list_body.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {

  TaskCubit() : super(TaskInitialState());
  static TaskCubit get(context) => BlocProvider.of(context);

  static TaskRepository taskRepository = TaskRepository();

  static String tasksFilter = 'All';

  static bool enableUpdate = false;

  static final listPageViewController = PageController();
  static List<Widget> listScreens = [
    const ListBodyScreen(tasks: [],),
    const ListBodyScreen(tasks: [],),
    const ListBodyScreen(tasks: [],),
  ];
void enableTaskUpdate(bool state){
  enableUpdate = state;
  emit(TaskRefresh());
}
  void refreshPage(){
    emit(TaskRefresh());
  }
  void filterWith(String filter){
    tasksFilter = filter;
    emit(TaskLoaded());
  }
  void loadTasks() async {
    emit(TaskLoading());
    try {
      await taskRepository.fetchTasks();
      emit(TaskLoaded());
    } catch (e) {
      print(e);
      emit(TaskError());
    }
  }

  Future<bool> loadSingleTask(String id) async {
    emit(TaskLoading());
    try {
      await taskRepository.fetchSingleTask(id);
      emit(TaskLoaded());
      return true;
    } catch (e) {
      print(e);
      emit(TaskError());
    }
    return false;
  }

  void addTask({required Task task}) async {
    emit(AddingTask());
    try {
      await taskRepository.addTask(task);
      emit(TaskAdded());

    } catch (_) {
      emit(TaskError());
    }
  }
  void updateTask({required Task task}) async {
    emit(UpdatingTask());
    try {
      await taskRepository.updateTask(task);
      emit(TaskUpdated());

    } catch (_) {
      emit(TaskError());
    }
  }

  void deleteTask({required String id}) async {
    emit(TaskOnDelete());
    try {
      await taskRepository.removeTask(id);
      emit(TaskDeleted());

    } catch (_) {
      emit(TaskError());
    }
  }

  void addTaskImage(String imagePath) async {
    emit(TaskImageLoading());
    try {
      await ImageRepository().uploadImage(File(imagePath));
      emit(TaskImageLoaded());
    } catch (_) {
      emit(TaskError());
    }
  }
}
