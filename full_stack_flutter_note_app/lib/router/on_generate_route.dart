import 'package:flutter/material.dart';
import 'package:full_stack_flutter_note_app/models/note_model.dart';
import 'package:full_stack_flutter_note_app/router/page_const.dart';
import 'package:full_stack_flutter_note_app/ui/add_note_page.dart';
import 'package:full_stack_flutter_note_app/ui/profile_page.dart';
import 'package:full_stack_flutter_note_app/ui/sign_in_page.dart';
import 'package:full_stack_flutter_note_app/ui/sign_up_page.dart';
import 'package:full_stack_flutter_note_app/ui/update_note_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.signInPage:
        return materialPageRoute(widget: SignInPage());

      case PageConst.signUpPage:
        return materialPageRoute(widget: SignUpPage());

      case PageConst.profilePage:
        {
          if (args is Map<String, String> && args.containsKey('uid')) {
            return materialPageRoute(widget: ProfilePage(uid: args['uid']!));
          } else {
            return materialPageRoute(widget: ErrorPage());
          }
        }

      case PageConst.addNotePage:
        {
          if (args is String) {
            return materialPageRoute(widget: AddNotePage(uid: args));
          } else {
            return materialPageRoute(widget: ErrorPage());
          }
        }

      case PageConst.updateNotePage:
        if (args is NoteModel) {
          return materialPageRoute(widget: UpdateNotePage(note: args));
        } else {
          return materialPageRoute(widget: ErrorPage());
        }

      default:
        return materialPageRoute(widget: ErrorPage());
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Center(
        child: Text("Error"),
      ),
    );
  }
}

MaterialPageRoute materialPageRoute({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}

Future<void> pushAppFirstRoute(BuildContext context,
    {required String route, Object? arguments}) {
  return Navigator.pushNamedAndRemoveUntil(
    context,
    route,
    (route) => false,
    arguments: arguments,
  );
}

Future<void> pushRoute(BuildContext context,
    {required String route, Object? arguments}) {
  return Navigator.pushNamed(
    context,
    route,
    arguments: arguments,
  );
}
