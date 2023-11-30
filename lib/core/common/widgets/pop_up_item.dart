import 'package:flutter/material.dart';

class PopupItem extends StatelessWidget {
  const PopupItem({
    required this.tittle,
    required this.icon,
    super.key,
  });

  final String tittle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tittle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon,
      ],
    );
  }
}
