//
// class UserApiHelper {
//   static const String baseUrl = 'http://192.168.1.6:3000/api';
//
//   Future<List<User>> getAllUsers() async {
//     final response = await http.get(Uri.parse('$baseUrl/users'));
//
//     if (response.statusCode == 200) {
//       Iterable jsonResponse = json.decode(response.body);
//       AppCubit.adminUsers.addAll(
//           List<User>.from(jsonResponse.map((model) => User.fromJson(model))));
//
//       AppCubit.adminUsers.forEach((element) {
//         print('${element.userName}====>${element.password}');
//       });
//       return AppCubit.adminUsers;
//     } else {
//       throw Exception('Failed to load Users');
//     }
//   }
//
//   Future<User> getUserById(int id) async {
//     final response = await http.get(Uri.parse('$baseUrl/users/$id'));
//
//     if (response.statusCode == 200) {
//       print(response.body);
//       return User.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load User');
//     }
//   }
//   Future<User> createUser(User user) async {
//
//     print(jsonEncode(user));
//     final response = await http.post(
//         Uri.parse('$baseUrl/users/'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(user));
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//
//       return User.fromJson(json.decode(response.body));
//     } else {
//       print("${response.body}===>${response.statusCode}");
//       throw Exception('Failed to create User');
//     }
//   }
//
// /// ###########################################################################################
//   Future<User> updateUser(int id, User user) async {
//     final response = await http.put(Uri.parse('$baseUrl/users/$id'),body: user.toJson());
//
//     if (response.statusCode == 200) {
//       return User.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to update User');
//     }
//   }
//
//
//   Future<User> deleteUser(int id) async {
//     final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
//
//     if (response.statusCode == 200) {
// //      print(response.body);
//       return User.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to delete User');
//     }
//   }
// }