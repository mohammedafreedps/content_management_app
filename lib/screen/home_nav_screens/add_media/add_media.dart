import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum PlatformType { instagram, facebook, both }

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({super.key});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  PlatformType _selectedPlatform = PlatformType.instagram;
  bool _isStory = false;

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // -------- MEDIA PLACEHOLDER --------
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                BorderRadius.circular(AppRadius.lg),
                          ),
                          width: width * 0.8,
                          height: width * 0.8,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.video_collection_sharp,
                            size: width * 0.1,
                            color:
                                Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // -------- DESCRIPTION --------
                      TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          alignLabelWithHint: true,
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // -------- PLATFORM SELECTION --------
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Platform',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),

                      RadioGroup<PlatformType>(
                        groupValue: _selectedPlatform,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedPlatform = value;
                          });
                        },
                        child: Column(
                          children: const [
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

                      SizedBox(height: AppSpacing.md),

                      // -------- STORY CHECKBOX --------
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Is this a Story?'),
                        value: _isStory,
                        onChanged: (value) {
                          setState(() {
                            _isStory = value ?? false;
                          });
                        },
                      ),

                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),

              // -------- UPLOAD BUTTON --------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: upload logic
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
