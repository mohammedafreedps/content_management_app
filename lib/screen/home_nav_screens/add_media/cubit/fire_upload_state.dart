part of 'fire_upload_cubit.dart';

@immutable
sealed class FileUploadState {}

final class FireUploadInitial extends FileUploadState {}

final class UploadingState extends FileUploadState{
  final double progress;
  UploadingState({required this.progress});
}

final class UploadingErrorState extends FileUploadState{
  final String message ;
  UploadingErrorState({required this.message});
}

final class FileUPloadedState extends FileUploadState{}