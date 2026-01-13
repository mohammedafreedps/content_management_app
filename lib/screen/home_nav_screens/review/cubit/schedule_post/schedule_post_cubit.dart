import 'package:bloc/bloc.dart';
import 'package:content_managing_app/services/firebase_funtions/firebase_schedule_post_functions.dart';
import 'package:meta/meta.dart';

part 'schedule_post_state.dart';

class SchedulePostCubit extends Cubit<SchedulePostState> {
  SchedulePostCubit() : super(SchedulePostInitial());

  Future schedulePost({required String postId, required String scheduledDate})async{
    emit(SchedulingPostState());
    try {
      await FirebaseScheduledPostFunctions.instance.updateScheduledDate(postId: postId, scheduledDate: scheduledDate);
      emit(SchedulingSuccussState());
    } catch (e) {
      emit(SchedulingFailedState(message: e.toString()));
    }
  }
}