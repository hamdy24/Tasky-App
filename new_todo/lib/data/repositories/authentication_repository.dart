import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_todo/data/data_sources/cache_helper.dart';

import '../../domain/models/user.dart';
import '../../presentation/task_cubit/authentication/authenticationCubit.dart';



class AuthenticationRepository {

  static const String baseUrl = 'https://todo.iraqsapp.com/auth';


  Future<bool> isSignedIn() async {

    final response = await http.get(
      Uri.parse('$baseUrl/profile/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
      },
    );
    bool res;
    var decodedResponse= json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      res = true;
      AuthenticationCubit.userID = decodedResponse['_id'];
      print('User is Looooogged_______________________________________');
    }
    else{
      print('NOT Logged_______________________${AuthenticationCubit.accessToken}____________________________');
      print(decodedResponse);
      res = false;
    }
    return res;
  }

  Future<bool> refreshOldToken() async{

    final response = await http.get(
      Uri.parse('$baseUrl/refresh-token?token=${AuthenticationCubit.refreshToken}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
      },
    );

    bool res;
    if (response.statusCode == 200||response.statusCode == 201 ) {
      res = true;
      final decodedResponse = json.decode(response.body);
      print(decodedResponse['access_token']);
      AuthenticationCubit.accessToken = decodedResponse['access_token'];
      CacheHelper.storeData(key: 'accessToken', value: AuthenticationCubit.accessToken);
    }else{
      res = false;
    }
    return res;
  }


  Future<void> signIn(String phone, String password) async {
    AuthenticationCubit.userID = '';
    AuthenticationCubit.accessToken ='';
    AuthenticationCubit.refreshToken = '';

    final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "phone" : phone,
          "password" : password
        })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);
      AuthenticationCubit.userID = decodedResponse['_id'];
      AuthenticationCubit.accessToken = decodedResponse['access_token'];
      AuthenticationCubit.refreshToken = decodedResponse['refresh_token'];
      CacheHelper.storeData(key: 'refreshToken', value: AuthenticationCubit.refreshToken);
      CacheHelper.storeData(key: 'accessToken', value: AuthenticationCubit.accessToken);
      print('--------------- LOGIN SUCCESS ----------------');
      print('ID >>> ${ AuthenticationCubit.userID }');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to login User');
    }
  }
  Future<void> signUp(User newUser) async {
    final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "phone" : newUser.phone,
          "password" : newUser.password,
          "displayName" : newUser.name,
          "experienceYears" : newUser.experienceYears,
          "address" : newUser.address,
          "level" : newUser.level //fresh , junior , midLevel , senior
        })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);
      AuthenticationCubit.userID = decodedResponse['_id'];
      // AuthenticationCubit.accessToken = decodedResponse['access_token'];
      // AuthenticationCubit.refreshToken = decodedResponse['refresh_token'];
      print('--------------- Register SUCCESS ----------------');
      print('ID >>> ${ AuthenticationCubit.userID }');

    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to create User');
    }
  }

  Future<void> signOut(String token) async {
    final response = await http.post(
        Uri.parse('$baseUrl/logout/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
        },
        body: jsonEncode({
          "token" :token
        })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);
      AuthenticationCubit.userID = '';
      AuthenticationCubit.accessToken ='';
      AuthenticationCubit.refreshToken = '';
      print('--------------- Logout SUCCESS ----------------');
      print(decodedResponse);
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to Sign Out');
    }
  }


  Future<void> getProfile() async {
    final response = await http.get(
        Uri.parse('$baseUrl/profile/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
        },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = json.decode(response.body);
      AuthenticationCubit.userID = decodedResponse['_id'];
      AuthenticationCubit.userName = decodedResponse['displayName'];
      AuthenticationCubit.userPhone = decodedResponse['username'];
      AuthenticationCubit.userYears = decodedResponse['experienceYears'];
      AuthenticationCubit.userAddress = decodedResponse['address'];
      AuthenticationCubit.userLevel = decodedResponse['level'];
      print(AuthenticationCubit.accessToken);

      print('--------------- Profile Retrieved ----------------');
    } else {
      print("${response.body}===>${response.statusCode}");
      throw Exception('Failed to get User Profile');
    }
  }
}
