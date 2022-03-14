import 'package:flutter/material.dart';

class PublishVideoPage extends StatefulWidget {
  const PublishVideoPage({Key? key}) : super(key: key);

  @override
  State<PublishVideoPage> createState() => _PublishVideoPageState();
}

class _PublishVideoPageState extends State<PublishVideoPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'video',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
