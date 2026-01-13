part of 'schedule_post_cubit.dart';

@immutable
sealed class SchedulePostState {}

final class SchedulePostInitial extends SchedulePostState {}

final class SchedulingPostState extends SchedulePostState{}

final class SchedulingFailedState extends SchedulePostState{
  final String message;
  SchedulingFailedState({required this.message});
}

final class SchedulingSuccussState extends SchedulePostState{}