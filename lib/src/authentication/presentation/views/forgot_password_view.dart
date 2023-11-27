import 'package:education_app/core/common/widgets/rounded_button.dart';
import 'package:education_app/core/common/widgets/text_field.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  static const routeName = '/forgot-password';

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  bool visibleTextField = true;
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
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
          } else if (state is ForgotPasswordSent) {
            setState(() {
              visibleTextField = !visibleTextField;
            });
          }
        },
        builder: (context, state) {
          return Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  visibleTextField
                      ? 'Provide your email and we wiil send you a link '
                          'to reset your password'
                      : "We've sent you an email with a link to reset your "
                          'password. Please check your email',
                ),
                const SizedBox(
                  height: 25,
                ),
                Visibility(
                  visible: visibleTextField,
                  child: Form(
                    key: formKey,
                    child: IField(
                      controller: emailController,
                      hintText: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Visibility(
                    visible: visibleTextField,
                    child: RoundedButton(
                      label: 'Sent email',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthenticationBloc>().add(
                                ForgotPasswordEvent(
                                  emailController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
