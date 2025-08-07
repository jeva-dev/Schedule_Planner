import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scheduleplanner/model.dart';

class GetAllPosts {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  /// Create a new post
  static Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  /// Update an existing post
  static Future<Post> updatePost(int id, Post updatedPost) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedPost.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update post');
    }
  }

  ///Update specific id
  static Future<List<Post>> fetchPostsById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode == 201) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  /// Delete a post by ID
  static Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
