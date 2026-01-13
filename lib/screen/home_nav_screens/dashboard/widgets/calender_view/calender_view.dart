import 'package:content_managing_app/helper_funtions/calender_detail.dart';
import 'package:content_managing_app/main.dart';
import 'package:content_managing_app/screen/home_nav_screens/dashboard/widgets/calender_view/widgets/days_toggle_button.dart';
import 'package:content_managing_app/theme/app_radious.dart';
import 'package:content_managing_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class CalenderView extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Set<DateTime> scheduledDates;

  const CalenderView({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.scheduledDates,
  });

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  bool isWeek = true;

  final CalendarDetail calendar = CalendarDetail();

  late List<DateTime> weekDates;
  late List<DateTime> monthDates;

  @override
  void initState() {
    super.initState();
    weekDates = calendar.currentWeekDates;
    monthDates = calendar.currentMonthDates;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DaysToggleButton(
              label: 'Week',
              isActive: isWeek,
              onTap: () => setState(() => isWeek = true),
            ),
            const SizedBox(width: AppSpacing.sm),
            DaysToggleButton(
              label: 'Month',
              isActive: !isWeek,
              onTap: () => setState(() => isWeek = false),
            ),
          ],
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isWeek
                  ? _weekView(
                      context,
                      isMobile,
                      isTablet,
                      isDesktop,
                      const ValueKey('week'),
                    )
                  : _monthView(
                      context,
                      isMobile,
                      isTablet,
                      isDesktop,
                      const ValueKey('month'),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // WEEK VIEW
  // =========================================================
  Widget _weekView(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    ValueKey key,
  ) {
    final double itemWidth = isMobile
        ? 56
        : isTablet
            ? 72
            : 88;
    final double viewHeight = isMobile
        ? 80
        : isTablet
            ? 96
            : 110;

    return Container(
      key: key,
      height: viewHeight,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appColors.calendarActive,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppRadius.md),
          bottomLeft: Radius.circular(AppRadius.md),
          bottomRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: weekDates.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = weekDates[index];
          final bool isSelected = _isSameDate(date, widget.selectedDate);
          final bool hasPost = _hasPost(date);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: itemWidth,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.surface
                    : context.appColors.calendarActive,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (hasPost)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(calendar.weekShort(date),
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Text(date.day.toString(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),

                  if (hasPost)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.star,
                          size: 14, color: Colors.amber),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // MONTH VIEW
  // =========================================================
  Widget _monthView(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    ValueKey key,
  ) {
    final int columns = isDesktop ? 8 : 7;
    final double spacing = isMobile ? 12 : 8;

    return Container(
      key: key,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appColors.calendarActive,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: monthDates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 1 / 2,
        ),
        itemBuilder: (context, index) {
          final date = monthDates[index];
          final bool isSelected = _isSameDate(date, widget.selectedDate);
          final bool hasPost = _hasPost(date);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.surface
                    : context.appColors.calendarActive,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (hasPost)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(calendar.weekShort(date),
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(date.day.toString(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),

                  if (hasPost)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.star,
                          size: 12, color: Colors.amber),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasPost(DateTime date) {
    return widget.scheduledDates.any((d) =>
        d.year == date.year &&
        d.month == date.month &&
        d.day == date.day);
  }
}
