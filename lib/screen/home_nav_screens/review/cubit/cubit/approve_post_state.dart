part of 'approve_post_cubit.dart';

@immutable
sealed class ApprovePostState {}

final class ApprovePostInitial extends ApprovePostState {}

final class ApprovedState extends ApprovePostState{}

final class ApproveFailedState extends ApprovePostState{
  final String message;
  ApproveFailedState({required this.message});
}