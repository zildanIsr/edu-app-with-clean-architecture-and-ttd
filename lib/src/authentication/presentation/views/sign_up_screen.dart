import 'package:education_app/core/common/widgets/rounded_button.dart';
import 'package:education_app/core/extensions/context_container.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:education_app/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:education_app/src/authentication/presentation/widgets/sign_up_form.dart';
import 'package:education_app/src/dashboard/presentation/views/dasboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpSreen extends StatefulWidget {
  const SignUpSreen({super.key});

  static const routeName = '/sign_up';

  @override
  State<SignUpSreen> createState() => _SignUpSreenState();
}

class _SignUpSreenState extends State<SignUpSreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPassword.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is SignedUp) {
            context.read<AuthenticationBloc>().add(
                  SignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
          } else if (state is SignedIn) {
            context.userProvider.initUser(state.user as UserModel);
            Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
          }
        },
        builder: (context, state) {
          return Container(
            constraints: const BoxConstraints.expand(),
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const FractionallySizedBox(
                      widthFactor: .8,
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Easy to learn, discover more skills.',
                        style: TextStyle(
                          fontFamily: Fonts.aeonik,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Baseline(
                          baseline: 100,
                          baselineType: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                SignInScreen.routeName,
                              );
                            },
                            child: const Text(
                              'Login account',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignUpForm(
                      emailController: emailController,
                      formKey: formKey,
                      passwordController: passwordController,
                      confirmPassword: confirmPassword,
                      fullNameController: fullNameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (state is AuthLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      RoundedButton(
                        label: 'Register',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthenticationBloc>().add(
                                  SignUpEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    fullName: fullNameController.text.trim(),
                                  ),
                                );
                          }
                        },
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
