import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkImageHandler extends StatelessWidget {

  final String imgUrl;
  final String onErrAsset;
  const NetworkImageHandler({
    super.key,
    required this.imgUrl,
    required this.onErrAsset,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkImageExists(imgUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
            return SizedBox(
              width:100,
              child: Center(
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Image.asset(onErrAsset),
                ),
              ),
            );
          }
          return SizedBox(
            width: 100,
            child: Center(
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(imgUrl),
              ),
            ),
          );
        } else {
          return const SizedBox(
            width: 100,
            child: Center(
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }


  Future<bool> _checkImageExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

}