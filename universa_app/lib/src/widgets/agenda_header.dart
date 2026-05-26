import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class AgendaDayItem {
  final DateTime date;
  final bool showDot;
  final bool enabled;

  const AgendaDayItem({
    required this.date,
    this.showDot = false,
    this.enabled = true,
  });

  static const _weekdayAbbrevs = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB'];

  String get weekdayAbbrev => _weekdayAbbrevs[_weekdayIndex];

  int get day => date.day;

  int get _weekdayIndex => date.weekday == DateTime.sunday ? 0 : date.weekday;
}

class AgendaHeader extends StatefulWidget {
  final String monthYear;
  final List<AgendaDayItem> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;
  final bool canGoPreviousMonth;
  final bool canGoNextMonth;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  const AgendaHeader({
    super.key,
    required this.monthYear,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
    this.canGoPreviousMonth = false,
    this.canGoNextMonth = true,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  @override
  State<AgendaHeader> createState() => _AgendaHeaderState();
}

class _AgendaHeaderState extends State<AgendaHeader> {
  static const _dayItemWidth = 48.0;
  static const _daySpacing = 8.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AgendaHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.days.length != widget.days.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients || widget.days.isEmpty) return;

    final targetOffset = (widget.selectedIndex * (_dayItemWidth + _daySpacing))
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.headerBg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agenda',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  _MonthArrow(
                    icon: Icons.chevron_left,
                    enabled: widget.canGoPreviousMonth,
                    onTap: widget.onPreviousMonth,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.monthYear,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentPurple,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _MonthArrow(
                    icon: Icons.chevron_right,
                    enabled: widget.canGoNextMonth,
                    onTap: widget.onNextMonth,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 72,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.days.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: _daySpacing),
              itemBuilder: (context, index) {
                final item = widget.days[index];
                final isSelected =
                    item.enabled && index == widget.selectedIndex;
                final isDisabled = !item.enabled;

                return GestureDetector(
                  onTap: item.enabled ? () => widget.onDaySelected(index) : null,
                  child: Opacity(
                    opacity: isDisabled ? 0.35 : 1,
                    child: SizedBox(
                      width: _dayItemWidth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.agendaDaySelectedBg
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item.weekdayAbbrev,
                              style: GoogleFonts.roboto(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.day}',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.navInactive,
                              ),
                            ),
                            if (!isDisabled &&
                                (item.showDot || isSelected)) ...[
                              const SizedBox(height: 4),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.navInactive,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _MonthArrow({
    required this.icon,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(
        icon,
        size: 20,
        color: enabled
            ? AppColors.accentPurple
            : AppColors.accentPurple.withValues(alpha: 0.3),
      ),
    );
  }
}
