import 'package:content_managing_app/main.dart';
import 'package:content_managing_app/models/uploaded_media_model.dart';
import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text(widget.uploadedMedia.isStory ? 'Story' : 'Post')),

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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(
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

            // Placeholder comments list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, index) {
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
                          child: const Text('This is a comment preview'),
                        ),
                      ),
                    ],
                  ),
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
                BoxShadow(color: Colors.black.withValues(alpha:  0.05), blurRadius: 8),
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
                IconButton(
                  onPressed: () {
                    final text = _commentController.text.trim();
                    if (text.isEmpty) return;

                    debugPrint('Send comment: $text');
                    _commentController.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
