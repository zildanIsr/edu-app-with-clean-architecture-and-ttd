import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/extensions/string_extension.dart';
import 'package:education_app/src/profile/presentation/widgets/edit_profile_textfield.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.bioController,
    required this.oldPasswordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController bioController;
  final TextEditingController oldPasswordController;
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditProfileTextfield(
            controller: fullNameController,
            titleField: 'Full Name',
            hintText: context.currentUser!.fullName,
          ),
          EditProfileTextfield(
            controller: emailController,
            titleField: 'Email',
            hintText: context.currentUser!.email.obscureEmail,
          ),
          EditProfileTextfield(
            controller: oldPasswordController,
            titleField: 'Current Password',
            hintText: '******',
          ),
          StatefulBuilder(
            builder: (_, setState) {
              oldPasswordController.addListener(
                () => setState(() {}),
              );
              return EditProfileTextfield(
                controller: passwordController,
                titleField: 'New Password',
                hintText: '******',
                readOnly: oldPasswordController.text.isEmpty,
              );
            },
          ),
          EditProfileTextfield(
            controller: bioController,
            titleField: 'Bio',
            hintText: context.currentUser!.bio,
          ),
        ],
      ),
    );
  }
}
