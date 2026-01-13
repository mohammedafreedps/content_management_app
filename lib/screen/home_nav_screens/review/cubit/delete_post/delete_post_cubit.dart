import 'package:bloc/bloc.dart';
import 'package:content_managing_app/services/firebase_funtions/firebase_delete_manager.dart';
import 'package:meta/meta.dart';

part 'delete_post_state.dart';

class DeletePostCubit extends Cubit<DeletePostState> {
  DeletePostCubit() : super(DeletePostInitial());

  Future<void> deletePost({required String postId}) async {
    try {
      emit(DeletingPostState());

      await PostDeleteManager.instance.deletePost(
        postId: postId,
      );

      emit(PostDeletedSuccussState());
    } catch (e) {
      emit(
        DeletingPostFailedState(
          message: e.toString(),
        ),
      );
    }
  }
}

