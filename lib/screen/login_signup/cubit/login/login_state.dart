part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LogInLoadingState extends LoginState{}

final class LogInErrorState extends LoginState{
  final String message;
  LogInErrorState(this.message);
}

final class LogedInState extends LoginState{}