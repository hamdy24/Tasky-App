import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:new_todo/screens/onBoarding.dart';
import 'package:new_todo/screens/task/qrHelper.dart';
import 'package:new_todo/shared/cubits/task_cubit/authentication/authenticationCubit.dart';
import 'package:new_todo/shared/cubits/task_cubit/image/imageCubit.dart';
import 'package:new_todo/shared/cubits/task_cubit/task/taskCubit.dart';
import 'package:new_todo/shared/network/local/cache_helper.dart';
import 'package:new_todo/shared/styles/themes.dart';
import 'models/task.dart';
import 'screens/task/task_list_screen.dart';
import 'screens/task/task_detail_screen.dart';
import 'screens/task/add_task_screen.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/signup_screen.dart';
import 'screens/user/profile_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await CacheHelper.init();
  AuthenticationCubit.refreshToken = CacheHelper.getData(key: 'refreshToken')??'';
  AuthenticationCubit.accessToken = CacheHelper.getData(key: 'accessToken')??'';
  await AuthenticationCubit().checkAuth().timeout(Duration(seconds: 2),onTimeout: () {
    print('TIMEOUT---> Changing to offline');
    // AppCubit.isConnected = false;
  },);
  runApp(const MyApp());
  FlutterNativeSplash.remove();

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isBoarded = CacheHelper.getData(key: 'isBoarded')?? false;
    AuthenticationCubit.refreshToken = CacheHelper.getData(key: 'refreshToken')??'';
    AuthenticationCubit.accessToken = CacheHelper.getData(key: 'accessToken')??'';
    return MultiBlocProvider(
      providers: [

        BlocProvider(create: (context) => ImageCubit()),
        BlocProvider(
          create: (context) => AuthenticationCubit(
          )..checkAuth(),
        ),
        BlocProvider(
          create: (context) => TaskCubit(
          )..loadTasks(),
        ),
      ],
      child: MaterialApp(
        title: 'ToDo',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        initialRoute: isBoarded?
        ( AuthenticationCubit.isUserLogged?'/tasks':'/login')
            : '/boarding',
        routes: {
          '/boarding': (context) =>  const OnBoarding(),
          '/login': (context) =>  const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/tasks': (context) => const TaskListScreen(),
          '/task-detail': (context) => TaskDetailScreen(
              task: ModalRoute.of(context)!.settings.arguments as Task
          ),
          '/add-task': (context) => const AddTaskScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/qr': (context) => const QRScannerHome(),
        },
      ),
    );
  }
}
