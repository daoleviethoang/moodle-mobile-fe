import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final String? text;

  const LoadingCard({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          Container(height: 16),
          Text(
            text ?? 'Loading',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String? text;

  const ErrorCard({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 54,
            color: Theme.of(context).colorScheme.error,
          ),
          Container(height: 16),
          Text(
            text ?? 'Something happened. Please try again later.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }
}