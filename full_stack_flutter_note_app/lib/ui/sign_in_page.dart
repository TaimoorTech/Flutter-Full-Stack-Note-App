import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_flutter_note_app/cubit/auth/auth_cubit.dart';
import 'package:full_stack_flutter_note_app/cubit/credential/credential_cubit.dart';
import 'package:full_stack_flutter_note_app/models/user_model.dart';
import 'package:full_stack_flutter_note_app/ui/home_page.dart';
import 'package:full_stack_flutter_note_app/ui/sign_up_page.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/common/common.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_button.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_text_field.dart';

import '../router/on_generate_route.dart';
import '../router/page_const.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static Future<void> push(BuildContext context) {
    return pushAppFirstRoute(context, route: PageConst.signInPage);
  }

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
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
        // if (credentialState is CredentialLoading) {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(uid: authState.uid);
              } else {
                return _bodyWidget(credentialState is CredentialLoading);
              }
            },
          );
        }
        return _bodyWidget(credentialState is CredentialLoading);
      },
    );
  }

  Widget _bodyWidget(bool isLoading) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign In"),
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
              title: "Login",
              onTap: _submitSignIn,
              isLoading: isLoading,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text("Don't have an account"),
                CustomTextButton(
                  onTap: () => SignUpPage.push(context),
                  title: "Sign Up",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _submitSignIn() {
    if (_emailController.text.trim().isEmpty) {
      showSnackBarMessage(context, message: "Enter Email");
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      showSnackBarMessage(context, message: "Enter Password");
      return;
    }
    context.read<CredentialCubit>().callSignIn(
          UserModel(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }
}
