import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:full_stack_flutter_note_app/models/user_model.dart';
import 'package:full_stack_flutter_note_app/repository/network_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final networkRepository = NetworkRepository();

  UserCubit() : super(UserInitial());

  Future<void> myProfile(String uid) async {
    emit(UserLoading());
    try {
      final userData = await networkRepository.myProfile(uid);
      emit(UserSuccess(user: userData));
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateProfile(UserModel user) async {
    emit(UpdateUserLoading());
    try {
      await networkRepository.updateProfile(user);
      await myProfile(user.uid!);
    } catch (_) {
      emit(UserFailure());
    }
  }
}
