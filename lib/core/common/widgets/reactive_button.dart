import 'package:flutter/material.dart';

class ReactiveButton extends StatelessWidget {
  const ReactiveButton({
    required this.isLoading,
    required this.isDisabled,
    required this.text,
    super.key,
    this.onPressed,
  });

  final bool isLoading;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final String text;

  bool get normal => !isLoading && !isDisabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: normal ? onPressed : null,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Text(text),
    );
  }
}
