part of 'delete_post_cubit.dart';

@immutable
sealed class DeletePostState {}

final class DeletePostInitial extends DeletePostState {}

final class DeletingPostFailedState extends DeletePostState{
  final String message;
  DeletingPostFailedState({required this.message});
}

final class PostDeletedSuccussState extends DeletePostState{
}

final class DeletingPostState extends DeletePostState{}