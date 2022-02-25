import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublishPage extends ConsumerStatefulWidget {
  const PublishPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublishPageState();
}

class _PublishPageState extends ConsumerState<PublishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Publish Page'),
      ),
    );
  }
}
