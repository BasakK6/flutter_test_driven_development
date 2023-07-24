import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_driven_development/features/home/model/post.dart';
import 'package:test_driven_development/features/home/service/post_service.dart';

import 'post_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late String apiUrl;
  late MockDio mockDio;

  setUp((){
    mockDio = MockDio();
    apiUrl = "https://jsonplaceholder.typicode.com/comments";
  });

  tearDown(() => (){
    mockDio.close();
  });

  group("Posts Service Tests -", () {
    //Success Scenario
    test("Should return list of post data if the Post Service can fetch posts", () async {
      //ARRANGE
      final responseStub = [
        {
          "postId": 1,
          "id": 1,
          "name": "id labore ex et quam laborum",
          "email": "Eliseo@gardner.biz",
          "body":
              "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
        },
        {
          "postId": 1,
          "id": 2,
          "name": "quo vero reiciendis velit similique earum",
          "email": "Jayne_Kuhic@sydney.com",
          "body":
              "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
        },
      ];

      when(mockDio.get(apiUrl)).thenAnswer((realInvocation) async => Response(
            data: responseStub,
            requestOptions: RequestOptions(),
            statusCode: HttpStatus.ok,
          ));

      //ACT
      final postsService = PostService(mockDio);
      final result = await postsService.fetchData();

      //ASSERT
      expect(result, isA<List<Post>>());
      expect(result.length, 2);
    });
  });

  //Error Scenario
  test("Should throw an exception if the Post Service can't fetch the posts",
      () async {
    //ARRANGE
    when(mockDio.get(apiUrl)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.unauthorized,
        ));

    //ACT
    final postsService = PostService(mockDio);

    try{
      final result = await postsService.fetchData();
      //ASSERT
      expect(result, throwsException);
    }
    catch(e){
      if (kDebugMode) {
        print("Exception caught");
      }
    }
  });
}
