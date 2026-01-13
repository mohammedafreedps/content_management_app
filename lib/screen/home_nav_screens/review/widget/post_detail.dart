import 'dart:io';

import 'package:content_managing_app/services/firebase_funtions/firebase_comment_functions.dart';
import 'package:content_managing_app/helper_funtions/format_comment_time.dart';
import 'package:content_managing_app/helper_funtions/to_date_key.dart';
import 'package:content_managing_app/main.dart';
import 'package:content_managing_app/models/uploaded_media_model.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/cubit/comment/comment_cubit.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/cubit/approve_post/approve_post_cubit.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/cubit/delete_post/delete_post_cubit.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/cubit/schedule_post/schedule_post_cubit.dart';
import 'package:content_managing_app/screen/widgets/comform_dialoge.dart';
import 'package:content_managing_app/screen/widgets/snack_bar_error_messenger.dart';
import 'package:content_managing_app/services/media_cache_service.dart';
import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetail extends StatefulWidget {
  final UploadedMedia uploadedMedia;

  const PostDetail({super.key, required this.uploadedMedia});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final TextEditingController _commentController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = context.screenSize;
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocListener<ApprovePostCubit, ApprovePostState>(
      listener: (context, state) {
        if (state is ApproveFailedState) {
          snackBarErrorMessage(context: context, message: state.message);
        }
        if (state is ApprovedState) {
          snackBarErrorMessage(
            context: context,
            message: 'Current Post Approved',
          );
        }
      },
      child: BlocListener<DeletePostCubit, DeletePostState>(
        listener: (context, state) {
          if (state is DeletingPostFailedState) {
            snackBarErrorMessage(context: context, message: state.message);
          }
          if (state is PostDeletedSuccussState) {
            Navigator.pop(context);
            snackBarErrorMessage(context: context, message: 'Post Deleted');
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(widget.uploadedMedia.isStory ? 'Story' : 'Post'),
            actions: [
              widget.uploadedMedia.isApproved
                  ? IconButton(
                      onPressed: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2040),
                        );
                        if (date == null) return;
                        context.read<SchedulePostCubit>().schedulePost(
                          postId: widget.uploadedMedia.id,
                          scheduledDate: toDateKey(date),
                        );
                      },
                      icon: Icon(Icons.schedule),
                    )
                  : SizedBox.shrink(),
              PopupMenuButton(
                onSelected: (value) async {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (_) => ConfirmDialog(
                        message: 'Do you want to delete this post',
                        title: 'Delete',
                        confirmText: 'yes',
                        cancelText: 'no',
                        onConfirm: () {
                          context.read<DeletePostCubit>().deletePost(
                            postId: widget.uploadedMedia.id,
                          );
                        },
                      ),
                    );
                  }
                  if (value == 'approve') {
                    context.read<ApprovePostCubit>().approvePost(
                      postId: widget.uploadedMedia.id,
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (!widget.uploadedMedia.isApproved)
                    const PopupMenuItem(
                      value: 'approve',
                      child: Text('Approve'),
                    ),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),

          // ================= CONTENT =================
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- MEDIA ----------
                Container(
                  width: screen.width * 0.9,
                  height: screen.height * 0.55,
                  decoration: BoxDecoration(
                    color: widget.uploadedMedia.storagePath.isEmpty
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  alignment: Alignment.center,
                  child: widget.uploadedMedia.storagePath.isNotEmpty
                      ? Hero(
                          tag: widget.uploadedMedia.id,
                          child: FutureBuilder<File>(
                            future: MediaCacheService.instance.getFile(
                              widget.uploadedMedia.storagePath,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Icon(Icons.error);
                              }

                              return Image.file(
                                snapshot.data!,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.content_copy_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ---------- DESCRIPTION ----------
                if (widget.uploadedMedia.description.isNotEmpty)
                  Text(
                    widget.uploadedMedia.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                const SizedBox(height: AppSpacing.xl),

                // ---------- COMMENTS PLACEHOLDER ----------
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirebaseCommentFunctions.instance.streamPostComments(
                    widget.uploadedMedia.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Failed to load comments'),
                      );
                    }

                    final comments = snapshot.data ?? [];

                    if (comments.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No comments yet'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (_, index) {
                        final comment = comments[index];
                        final bool isMe = comment['userId'] == currentUserId;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe) const CircleAvatar(radius: 16),
                              if (!isMe) const SizedBox(width: 8),

                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Theme.of(context).colorScheme.primary
                                              .withValues(alpha: 0.1)
                                        : Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // USERNAME (optional for self)
                                      if (!isMe)
                                        Text(
                                          '@${comment['userName'] ?? ''}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                              ),
                                        ),

                                      // COMMENT TEXT
                                      Text(
                                        comment['text'] ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      const SizedBox(height: 4),

                                      // TIME
                                      Text(
                                        formatCommentTime(comment['createdAt']),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (isMe) const SizedBox(width: 8),
                              if (isMe) const CircleAvatar(radius: 16),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // ================= COMMENT INPUT =================
          bottomNavigationBar: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment…',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    BlocConsumer<CommentCubit, CommentState>(
                      listener: (context, state) {
                        if (state is CommentFailedState) {
                          snackBarErrorMessage(
                            context: context,
                            message: state.message,
                          );
                        }
                        if (state is CommentedSuccsussState) {
                          _commentController.clear();
                        }
                      },
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {
                            final text = _commentController.text.trim();
                            if (text.isEmpty) return;
                            context.read<CommentCubit>().postComment(
                              postId: widget.uploadedMedia.id,
                              userName: widget.uploadedMedia.userName,
                              text: _commentController.text.trim(),
                            );
                            debugPrint('Send comment: $text');
                          },
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
