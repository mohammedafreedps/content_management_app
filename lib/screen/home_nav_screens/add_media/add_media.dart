import 'dart:io';

import 'package:content_managing_app/helper_funtions/file_picker.dart';
import 'package:content_managing_app/screen/home_nav_screens/add_media/cubit/fire_upload_cubit.dart';
import 'package:content_managing_app/screen/widgets/snack_bar_error_messenger.dart';
import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

enum PlatformType { instagram, facebook, both }

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({super.key});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  PlatformType _selectedPlatform = PlatformType.instagram;
  bool _isStory = false;

  PickedMedia? media;
  VideoPlayerController? _videoController;
  bool _videoError = false;

  final descriptionController = TextEditingController();

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ================= VIDEO INIT =================
  Future<void> _initVideo(File file) async {
    try {
      _videoError = false;
      _videoController?.dispose();

      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      controller
        ..setLooping(false)
        ..setVolume(1);

      controller.addListener(() {
        if (controller.value.hasError && !_videoError) {
          _videoError = true;
          snackBarErrorMessage(
            context: context,
            message: 'Failed to load video',
          );
        }
      });

      setState(() {
        _videoController = controller;
      });
    } catch (e, st) {
      debugPrint('Video init error: $e');
      debugPrintStack(stackTrace: st);
      snackBarErrorMessage(
        context: context,
        message: 'Video not supported or corrupted',
      );
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;

    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ================= MEDIA PICKER =================
                      GestureDetector(
                        onTap: () async {
                          final picked = await FilePickerService.pickMedia();

                          if (picked == null) {
                            snackBarErrorMessage(
                              context: context,
                              message: 'Pick any media',
                            );
                            return;
                          }

                          media = picked;

                          if (media!.type == MediaType.video) {
                            await _initVideo(media!.file);
                          } else {
                            _videoController?.dispose();
                            _videoController = null;
                          }

                          setState(() {});
                        },
                        child: Container(
                          width: width * 0.8,
                          height: width * 0.8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: media == null
                              ? Icon(
                                  Icons.video_collection_sharp,
                                  size: width * 0.1,
                                  color: Theme.of(context).colorScheme.surface,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                  child: media!.type == MediaType.image
                                      ? Image.file(
                                          media!.file,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : _buildVideoPreview(),
                                ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // ================= DESCRIPTION =================
                      TextField(
                        controller: descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(hintText: 'Description'),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // ================= PLATFORM =================
                      RadioGroup<PlatformType>(
                        groupValue: _selectedPlatform,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedPlatform = value);
                        },
                        child: const Column(
                          children: [
                            RadioListTile(
                              value: PlatformType.instagram,
                              title: Text('Instagram'),
                            ),
                            RadioListTile(
                              value: PlatformType.facebook,
                              title: Text('Facebook'),
                            ),
                            RadioListTile(
                              value: PlatformType.both,
                              title: Text('Both'),
                            ),
                          ],
                        ),
                      ),

                      CheckboxListTile(
                        title: const Text('Is this a Story?'),
                        value: _isStory,
                        onChanged: (v) => setState(() => _isStory = v ?? false),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= UPLOAD =================
              BlocConsumer<FileUploadCubit, FileUploadState>(
                listener: (context, state) {
                  if (state is UploadingErrorState) {
                    snackBarErrorMessage(
                      context: context,
                      message: state.message,
                    );
                  }
                  if (state is FileUPloadedState) {
                    descriptionController.clear();
                    setState(() {
                      media = null;
                      _isStory = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is UploadingState) {
                    return LinearProgressIndicator(value: state.progress);
                  }

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (media == null) {
                          snackBarErrorMessage(
                            context: context,
                            message: 'Media not found',
                          );
                          return;
                        }

                        context.read<FileUploadCubit>().uploadMediaToFirebase(
                          description: descriptionController.text,
                          platform: _selectedPlatform.name,
                          isStory: _isStory,
                          file: media!.file,
                          fileType: media!.type.name,
                        );
                      },
                      child: const Text('Upload'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= VIDEO PREVIEW =================
  Widget _buildVideoPreview() {
    if (_videoError) {
      return const Center(child: Icon(Icons.error, color: Colors.red));
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final isPlaying = _videoController!.value.isPlaying;

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.play_circle_fill,
              size: 64,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
