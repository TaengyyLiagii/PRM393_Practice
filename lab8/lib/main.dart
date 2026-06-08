import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Lab8App());
}

/// ======================
/// APP
/// ======================
class Lab8App extends StatelessWidget {
  const Lab8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 8 Networking',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const PostsScreen(),
    );
  }
}

/// ======================
/// MODEL
/// ======================
class Post {
  final int id;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

/// ======================
/// API SERVICE
/// ======================
class ApiService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com/posts';

  final http.Client client;

  ApiService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        return jsonData
            .map((item) => Post.fromJson(item))
            .toList();
      } else {
        throw Exception(
          'Failed to load posts (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}

/// ======================
/// SCREEN
/// ======================
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ApiService apiService = ApiService();

  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchPosts();
  }

  void retry() {
    setState(() {
      futurePosts = apiService.fetchPosts();
    });
  }

  Future<void> refreshPosts() async {
    setState(() {
      futurePosts = apiService.fetchPosts();
    });

    await futurePosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab 8 - API Posts"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {

          /// Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Something went wrong!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: retry,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          /// Empty
          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
          }

          /// Success
          final posts = snapshot.data!;

          return RefreshIndicator(
            onRefresh: refreshPosts,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(post.id.toString()),
                    ),
                    title: Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}