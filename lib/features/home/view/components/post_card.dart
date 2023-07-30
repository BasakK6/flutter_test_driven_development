import 'package:flutter/material.dart';
import 'package:test_driven_development/features/home/model/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
                leading: Text("${post.id ?? ""}"),
                title: Text(post.name ?? ""),
                subtitle: Text(post.body ?? ""),
              ),
      ),
    );
  }
}
