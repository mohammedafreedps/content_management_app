import 'package:content_managing_app/firebase_funtions/firebase_file_get_funtions.dart';
import 'package:content_managing_app/models/uploaded_media_model.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/widget/post_detail.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Review',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.question_mark)),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<UploadedMedia>>(
                  stream: FirebaseFileGetFunction.instance.streamGlobalFeed(),
                  builder: (context, snapshot) {
                    // ---------------- LOADING ----------------
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ---------------- ERROR ----------------
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went wrong',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];

                    // ---------------- EMPTY ----------------
                    if (items.isEmpty) {
                      return const Center(child: Text('No posts yet'));
                    }

                    // ---------------- LIST ----------------
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final media = items[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetail(uploadedMedia: items[index]),
                              ),
                            );
                          },
                          child: _ReviewCard(media: media),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================
// REVIEW CARD (clean, extendable)
// ===================================================
class _ReviewCard extends StatelessWidget {
  final UploadedMedia media;

  const _ReviewCard({required this.media});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                child: Icon(Icons.person, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                media.platform == 'both'
                    ? 'instagram & facebook'.toUpperCase()
                    : media.platform.toUpperCase(),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
              SizedBox(width: AppSpacing.md,),
              media.isApproved? Chip(
                  label: Text('Approved'),
                  visualDensity: VisualDensity.compact,
                ) : SizedBox.shrink(),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ---------------- MEDIA PLACEHOLDER ----------------
          AspectRatio(
            aspectRatio: 1,
            child: media.storagePath.isNotEmpty ? Hero(tag: media.id, child: Image.network(media.storagePath))  : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              child: media.status == 'pending_upload'
                  ? const Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.grey,
                    )
                  : media.type == 'video'
                  ? const Icon(Icons.play_circle_fill, size: 64)
                  : const Icon(Icons.image, size: 64),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ---------------- DESCRIPTION ----------------
          if (media.description.isNotEmpty)
            Text(
              media.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

          const SizedBox(height: AppSpacing.sm),

          // ---------------- FOOTER ----------------
          Row(
            children: [
              if (media.isStory)
                const Chip(
                  label: Text('Story'),
                  visualDensity: VisualDensity.compact,
                ),
              const Spacer(),
              Text(
                _formatDate(media.uploadedAt),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
