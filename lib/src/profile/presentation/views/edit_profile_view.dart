import 'dart:convert';
import 'dart:io';

import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/enums/user_enums.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:education_app/src/profile/presentation/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? pickedImage;

  @override
  void initState() {
    fullNameController.text = context.currentUser!.fullName.trim();
    bioController.text = context.currentUser!.bio?.trim() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  bool get nameChanged =>
      context.currentUser?.fullName.trim() != fullNameController.text.trim();

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get bioChanged =>
      context.currentUser?.bio?.trim() != bioController.text.trim();

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged =>
      !nameChanged &&
      !emailChanged &&
      !passwordChanged &&
      !bioChanged &&
      !imageChanged;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackbar(context, 'Profile update is Successfully');
          context.pop();
        } else if (state is AuthError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const NestedBackButton(),
            title: const Text('Edit Profile'),
            actions: [
              TextButton(
                onPressed: () {
                  if (nothingChanged) return;
                  final bloc = context.read<AuthenticationBloc>();

                  if (passwordChanged) {
                    if (oldPasswordController.text.isEmpty) {
                      CoreUtils.showSnackbar(
                        context,
                        'Please enter your old password',
                      );
                      return;
                    }
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.password,
                        data: jsonEncode({
                          'oldPassword': oldPasswordController.text.trim(),
                          'newPassword': passwordController.text.trim()
                        }),
                      ),
                    );
                  }
                  if (nameChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.userName,
                        data: fullNameController.text.trim(),
                      ),
                    );
                  }
                  if (emailChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.email,
                        data: emailController.text.trim(),
                      ),
                    );
                  }
                  if (bioChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.bio,
                        data: bioController.text.trim(),
                      ),
                    );
                  }
                  if (imageChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        action: UpdateUserAction.profilePic,
                        data: pickedImage,
                      ),
                    );
                  }
                },
                child: state is AuthLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          fullNameController.addListener(
                            () => refresh(() {}),
                          );
                          emailController.addListener(
                            () => refresh(() {}),
                          );
                          passwordController.addListener(
                            () => refresh(() {}),
                          );
                          bioController.addListener(
                            () => refresh(() {}),
                          );
                          return Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: nothingChanged
                                  ? Colors.grey
                                  : Colors.blueAccent,
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Builder(
                  builder: (context) {
                    final user = context.currentUser!;
                    final userImg =
                        user.profilePic == null || user.profilePic!.isEmpty
                            ? null
                            : user.profilePic;
                    return CircleAvatar(
                      maxRadius: 60,
                      minRadius: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pickedImage != null
                                    ? Colors.transparent
                                    : Colors.black.withOpacity(.5),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: pickedImage != null
                                      ? FileImage(pickedImage!)
                                      : userImg != null
                                          ? NetworkImage(
                                              userImg,
                                            )
                                          : const AssetImage(
                                              MediaRes.defaultUserImg,
                                            ) as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await pickImage();
                            },
                            icon: Icon(
                              (pickedImage != null || user.profilePic != null)
                                  ? Icons.edit
                                  : Icons.add_a_photo_rounded,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Image recomandation at least is 400 x 400',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF777E90)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                EditProfileForm(
                  fullNameController: fullNameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  bioController: bioController,
                  oldPasswordController: oldPasswordController,
                  formKey: formKey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
