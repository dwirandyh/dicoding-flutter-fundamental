import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;

  const ErrorMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.warning,
          size: 32,
          color: Colors.yellow,
        ),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center)
      ],
    );
  }
}
