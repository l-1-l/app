import 'package:flutter/material.dart';

class PublishSoundPage extends StatefulWidget {
  const PublishSoundPage({Key? key}) : super(key: key);

  @override
  State<PublishSoundPage> createState() => _PublishSoundPageState();
}

class _PublishSoundPageState extends State<PublishSoundPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'sound',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
