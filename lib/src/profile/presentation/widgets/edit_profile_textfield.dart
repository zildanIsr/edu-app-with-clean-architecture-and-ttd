import 'package:education_app/core/common/widgets/text_field.dart';
import 'package:flutter/material.dart';

class EditProfileTextfield extends StatelessWidget {
  const EditProfileTextfield({
    required this.titleField,
    required this.controller,
    super.key,
    this.hintText,
    this.readOnly = false,
  });

  final String titleField;
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            titleField,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        IField(
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
