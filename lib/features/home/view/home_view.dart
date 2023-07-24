import 'package:flutter/material.dart';
import 'package:test_driven_development/features/home/model/post.dart';
import 'package:test_driven_development/features/home/view/components/post_card.dart';
import 'package:test_driven_development/features/home/view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: postsFuture,
          builder: (context, asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.done:
                if (asyncSnapshot.hasError) {
                  return Text(asyncSnapshot.error.toString());
                } else {
                  //asyncSnapshot.hasData
                  return asyncSnapshot.data?.isEmpty ?? false
                      ? const Text("There is no data")
                      : buildPostsListView(asyncSnapshot);
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  ListView buildPostsListView(AsyncSnapshot asyncSnapshot) {
    return ListView.builder(
      itemCount: asyncSnapshot.data?.length,
      itemBuilder: (context, index) {
        return PostCard(post: asyncSnapshot.data?[index]);
      },
    );
  }
}
