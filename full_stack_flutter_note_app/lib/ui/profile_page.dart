import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_flutter_note_app/cubit/user/cubit/user_cubit.dart';
import 'package:full_stack_flutter_note_app/models/user_model.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_button.dart';
import 'package:full_stack_flutter_note_app/ui/widgets/custom_text_field.dart';

import '../router/on_generate_route.dart';
import '../router/page_const.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  static Future<void> push(BuildContext context, {required String uid}) {
    return pushRoute(context,
        route: PageConst.profilePage, arguments: {'uid': uid});
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    context.read<UserCubit>().myProfile(widget.uid);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Update Profile"),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        buildWhen: (previous, current) {
          return current is UserSuccess ||
              current is UserLoading ||
              current is UserFailure;
        },
        builder: (context, state) {
          if (state is UserSuccess) {
            _updateDetails(user: state.user);
            return Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username"),
                  SizedBox(height: 10),
                  CustomTextField(
                    hint: "Username",
                    controller: _usernameController,
                  ),
                  SizedBox(height: 20),
                  Text("Email"),
                  SizedBox(height: 10),
                  CustomTextField(
                    hint: "Email",
                    controller: _emailController,
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<UserCubit, UserState>(
                    buildWhen: (previous, current) {
                      return current is UpdateUserLoading;
                    },
                    builder: (context, state) {
                      return CustomGradientButton(
                        title: "Update Profile",
                        isLoading: state is UpdateUserLoading,
                        onTap: _updateProfile,
                      );
                    },
                  )
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _updateDetails({required UserModel user}) {
    _usernameController.text = user.username ?? "";
    _emailController.text = user.email ?? "";
  }

  void _updateProfile() {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return;
    }
    context
        .read<UserCubit>()
        .updateProfile(
          UserModel(
            uid: widget.uid,
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
          ),
        )
        .then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
      }
    });
  }
}
