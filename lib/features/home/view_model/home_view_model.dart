import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_driven_development/features/home/model/post.dart';
import 'package:test_driven_development/features/home/service/post_service.dart';
import 'package:test_driven_development/features/home/view/home_view.dart';

abstract class HomeViewModel extends State<HomeView>{
  late final PostService _postsService;
  late final Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    _postsService = PostService(Dio());
    postsFuture = _postsService.fetchData();
  }
}