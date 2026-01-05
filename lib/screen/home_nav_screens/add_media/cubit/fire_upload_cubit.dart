import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:content_managing_app/firebase_funtions/firebase_upload_funtions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'fire_upload_state.dart';

class FileUploadCubit extends Cubit<FileUploadState> {
  FileUploadCubit() : super(FireUploadInitial());
  final currentUser = FirebaseAuth.instance.currentUser?.uid;
  Future uploadMediaToFirebase({required File file, required String fileType,required String description, required bool isStory, required String platform}) async {
    try {
      if (currentUser == null) {
        emit(UploadingErrorState(message: 'Current user not found'));
        return;
      }
      FirebaseFileUpload.instance.uploadFile(
        description: description,
        isStory: isStory,
        platform: platform,
        file: file,
        folder: 'content',
        userId: currentUser!,
        fileType: fileType,
        onProgress: (v) {
          emit(UploadingState(progress: v));
        },
        onComplete: (m) {
          emit(FileUPloadedState());
        },
        onError: (error) {
          emit(UploadingErrorState(message: error));
        },
      );
    } catch (e) {
      emit(UploadingErrorState(message: e.toString()));
    }
  }
}
