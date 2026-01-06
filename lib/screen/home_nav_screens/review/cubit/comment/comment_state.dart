part of 'comment_cubit.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

final class CommentFailedState extends CommentState{
  final String message;
  CommentFailedState({required this.message});
}

final class CommentingState extends CommentState{}

final class CommentedSuccsussState extends CommentState{}