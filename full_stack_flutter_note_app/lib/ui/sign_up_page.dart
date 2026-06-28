import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_flutter_note_app/router/on_generate_route.dart';
import 'package:full_stack_flutter_note_app/router/page_const.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/common/common.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_button.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_text_field.dart';

import '../cubit/auth/auth_cubit.dart';
import '../cubit/credential/credential_cubit.dart';
import '../models/user_model.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static Future<void> push(BuildContext context) {
    return pushRoute(context, route: PageConst.signUpPage);
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          context.read<AuthCubit>().loggedIn(credentialState.user.uid!);
        }
        if (credentialState is CredentialFailure) {
          showSnackBarMessage(context, message: credentialState.errorMessage);
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(uid: authState.uid);
              } else {
                return _bodyWidget();
              }
            },
          );
        }
        return _bodyWidget();
      },
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign Up"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Text(
                "Note App",
                style: TextStyle(fontSize: 50),
              ),
            ),
            SizedBox(height: 50),
            CustomTextField(
              controller: _usernameController,
              hint: "Username",
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              hint: "Email",
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hint: "Password",
              obscureText: true,
              maxLines: 1,
            ),
            SizedBox(height: 20),
            CustomGradientButton(
              title: "Sign up",
              onTap: _submitSignup,
            ),
            SizedBox(height: 20),
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account"),
                CustomTextButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: "Sign In",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _submitSignup() {
    if (_usernameController.text.trim().isEmpty) {
      showSnackBarMessage(context, message: "Enter Username");
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      showSnackBarMessage(context, message: "Enter Email");
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      showSnackBarMessage(context, message: "Enter Password");
      return;
    }
    context.read<CredentialCubit>().callSignUp(
          UserModel(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }
}
