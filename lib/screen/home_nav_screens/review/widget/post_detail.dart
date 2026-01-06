import 'package:content_managing_app/firebase_funtions/firebase_comment_functions.dart';
import 'package:content_managing_app/helper_funtions/format_comment_time.dart';
import 'package:content_managing_app/main.dart';
import 'package:content_managing_app/models/uploaded_media_model.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/cubit/comment_cubit.dart';
import 'package:content_managing_app/screen/widgets/snack_bar_error_messenger.dart';
import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = context.screenSize;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.uploadedMedia.isStory ? 'Story' : 'Post'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'approve', child: Text('Approve')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
              const PopupMenuItem(value: 'schedule', child: Text('Schedule')),
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
                  ? Hero(tag: widget.uploadedMedia.id, child: Image.network(widget.uploadedMedia.storagePath))
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(radius: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ---------- COMMENT TEXT ----------
                                  Text(
                                    comment['text'] ?? '',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),

                                  const SizedBox(height: 4),

                                  // ---------- TIME ----------
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
    );
  }
}
