import 'dart:convert';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../shared/cubits/task_cubit/authentication/authenticationCubit.dart';


class ImageRepository{


  static const String baseUrl = 'https://todo.iraqsapp.com/todos';


  Future<String> uploadImage(File imageFile) async {
    var url = Uri.parse('https://todo.iraqsapp.com/upload/image');

    var request = http.MultipartRequest('POST', url);

    // Determine the mime type of the file
    var mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

    // Attach the file in the request
    var file = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
    );

    request.files.add(file);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AuthenticationCubit.accessToken}',
    });

    try {
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Image uploaded successfully!');
        // Handle the response if necessary
        var responseData = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseData);
        print(decodedResponse['image']);
        return decodedResponse['image'];
      } else {
        print('Image upload failed with status code: ${response.statusCode}');
        var responseData = await response.stream.bytesToString();
        print('Response data: $responseData');
        // Handle the error if necessary
        return 'Failed';
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return '';
  }

}