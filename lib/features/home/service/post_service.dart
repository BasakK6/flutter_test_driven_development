import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_driven_development/features/home/model/post.dart';

class PostService {
  final Dio _dio;
  final _apiUrl = "https://jsonplaceholder.typicode.com/comments";

  PostService(this._dio);

  Future<List<Post>> fetchData() async {
   final response = await _dio.get(_apiUrl);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Post.fromJson(item))
            .toList();
      }
    } else {
      throw (Exception("Couldn't retrieve data"));
    }
    return [];
  }
}
