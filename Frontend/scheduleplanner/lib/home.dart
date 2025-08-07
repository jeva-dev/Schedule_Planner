import 'package:flutter/material.dart';
import 'package:scheduleplanner/apifetch.dart';
import 'package:scheduleplanner/model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: GetAllPosts.fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        else if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        else if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text('No posts found.'));

        final posts = snapshot.data!;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(posts[i].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(posts[i].content),
                const SizedBox(height: 4),
                Text(
                  'ID: ${posts[i].id}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Text(posts[i].createdAt.toLocal().toString()),
          ),
        );
      },
    );
  }
}
