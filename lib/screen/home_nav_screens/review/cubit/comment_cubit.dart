import 'package:bloc/bloc.dart';
import 'package:content_managing_app/firebase_funtions/firebase_comment_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future postComment({required String postId, required String text, })async {
    emit(CommentingState());
    if(userId == null){
      emit(CommentFailedState(message: 'User Id failed'));
      return;
    }
    try {
      
      await FirebaseCommentFunctions.instance.postComment(postId: postId, userId: userId!, text: text, onSuccess: (){
        emit(CommentedSuccsussState());
      }, onError: (error){
        emit(CommentFailedState(message: error));
      });
    } catch (e) {
      emit(CommentFailedState(message: e.toString()));
    }
  }
}
