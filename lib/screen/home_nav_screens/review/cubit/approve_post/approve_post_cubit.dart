import 'package:bloc/bloc.dart';
import 'package:content_managing_app/firebase_funtions/firebase_post_approvel_manage.dart';
import 'package:meta/meta.dart';

part 'approve_post_state.dart';

class ApprovePostCubit extends Cubit<ApprovePostState> {
  ApprovePostCubit() : super(ApprovePostInitial());
  Future<void> approvePost({required String postId}) async {
    try {
      await PostApprovalManager.instance.approvePost(
        postId: postId,
      );

      emit(ApprovedState());
    } catch (e) {
      emit(
        ApproveFailedState(
          message: e.toString(),
        ),
      );
    }
    }
}
