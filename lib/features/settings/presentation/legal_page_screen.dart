import 'package:flutter/material.dart';
import 'package:habit_tracker_app/core/extension/context.dart';

class LegalPageScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalPageScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
