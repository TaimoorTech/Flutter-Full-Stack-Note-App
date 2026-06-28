part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

final class UserSuccess extends UserState {
  final UserModel user;

  const UserSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}

final class UpdateUserLoading extends UserState {
  @override
  List<Object> get props => [];
}

// final class UpdateUserSuccess extends UserState {
//   final UserModel user;

//   const UpdateUserSuccess({required this.user});

//   @override
//   List<Object> get props => [user];
// }

// final class UpdateUserFailure extends UserState {
//   @override
//   List<Object> get props => [];
// }
