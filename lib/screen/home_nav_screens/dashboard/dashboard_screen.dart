import 'package:content_managing_app/services/firebase_funtions/firebase_auth_funtions.dart';
import 'package:content_managing_app/services/firebase_funtions/firebase_schedule_post_functions.dart';
import 'package:content_managing_app/helper_funtions/to_date_key.dart';
import 'package:content_managing_app/models/uploaded_media_model.dart';
import 'package:content_managing_app/screen/home_nav_screens/dashboard/widgets/calender_view/calender_view.dart';
import 'package:content_managing_app/screen/home_nav_screens/review/widget/post_detail.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime selectedDate = DateTime.now();
  bool selctedDate = false;

  @override
  Widget build(BuildContext context) {
    final dateKey = toDateKey(selectedDate);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseAuthFunction.instance.signOut();
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // ---------------- CALENDAR ----------------
              StreamBuilder<Set<DateTime>>(
                stream: FirebaseScheduledPostFunctions.instance
                    .streamScheduledDaysForMonth(selectedDate),
                builder: (context, snapshot) {
                  final scheduledDates = snapshot.data ?? {};

                  return CalenderView(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() => selectedDate = date);
                    },
                    scheduledDates: scheduledDates,
                  );
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // ---------------- SCHEDULED POSTS ----------------
              Expanded(
                child: StreamBuilder<List<UploadedMedia>>(
                  stream: FirebaseScheduledPostFunctions.instance
                      .streamScheduledPostsForDate(dateKey),
                  builder: (context, snapshot) {
                    // ---------- LOADING ----------
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null && selctedDate) {
                          selctedDate = true;
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ---------- ERROR ----------
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Failed to load scheduled posts'),
                      );
                    }

                    final posts = snapshot.data ?? [];

                    // ---------- EMPTY ----------
                    if (posts.isEmpty) {
                      return Center(
                        child: Text(
                          'No posts scheduled for $dateKey',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    // ---------- LIST ----------
                    return ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetail(uploadedMedia: post),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // PLATFORM + STORY
                                Row(
                                  children: [
                                    Text(
                                      post.platform.toUpperCase(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                    const SizedBox(width: 8),
                                    if (post.isStory)
                                      const Chip(
                                        label: Text('Story'),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // DESCRIPTION
                                Text(
                                  post.description.isNotEmpty
                                      ? post.description
                                      : 'No description',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),

                                const SizedBox(height: 8),

                                // META INFO
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Scheduled: ${post.scheduledDate}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                    Text(
                                      'Uploaded: ${_formatDate(post.uploadedAt)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
