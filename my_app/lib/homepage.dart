import 'package:flutter/material.dart';
import 'package:my_app/square.dart';

class MyWidget extends StatelessWidget {
  // typed and const list is correct
  final List<String> _posts = const [
    'Post 1',
    'Post 2',
    'Post 3',
    'Post 4',
    'Post 5',
  ];

  // prefer using the super parameter shorthand
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return MySquare(child: _posts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
