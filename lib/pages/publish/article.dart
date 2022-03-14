import 'package:flutter/material.dart';

class PublishArticlePage extends StatefulWidget {
  const PublishArticlePage({Key? key}) : super(key: key);

  @override
  State<PublishArticlePage> createState() => _PublishArticlePageState();
}

class _PublishArticlePageState extends State<PublishArticlePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'article',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
