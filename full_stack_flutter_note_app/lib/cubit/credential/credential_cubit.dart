import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:full_stack_flutter_note_app/models/user_model.dart';
import 'package:full_stack_flutter_note_app/repository/network_repository.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final networkRepository = NetworkRepository();

  CredentialCubit() : super(CredentialInitial());

  Future<void> callSignUp(UserModel user) async {
    emit(CredentialLoading());
    try {
      final userData = await networkRepository.signup(user);
      emit(CredentialSuccess(userData));
    } on ServerException catch (e) {
      emit(CredentialFailure(e.errorMessage));
    }
  }

  Future<void> callSignIn(UserModel user) async {
    emit(CredentialLoading());
    try {
      final userData = await networkRepository.signIn(user);
      emit(CredentialSuccess(userData));
    } on ServerException catch (e) {
      emit(CredentialFailure(e.errorMessage));
    }
  }
}
