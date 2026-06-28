import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:full_stack_flutter_note_app/utils/shared_pref.dart';

part 'auth_state.dart';

final sharedPref = SharedPref();

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final uid = await sharedPref.getUid();

      if (uid != null) {
        emit(Authenticated(uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn(String uid) async {
    sharedPref.setUid(uid);
    emit(Authenticated(uid));
  }

  Future<void> logOut() async {
    sharedPref.setUid("");
    emit(UnAuthenticated());
  }
}
