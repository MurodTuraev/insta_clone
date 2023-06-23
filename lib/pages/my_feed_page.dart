import 'package:flutter/material.dart';

class MyFeedPage extends StatefulWidget {
  const MyFeedPage({Key? key}) : super(key: key);
  static final String id = "my_feed_page";

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Feed Page',),
      ),
    );
  }
}
