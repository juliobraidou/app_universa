import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ScheduleEventItem {
  final String time;
  final String subject;
  final String room;
  final String duration;
  final String themeKey;

  const ScheduleEventItem({
    required this.time,
    required this.subject,
    required this.room,
    required this.duration,
    required this.themeKey,
  });

  Color get accentColor => _themeColors.$1;

  Color get backgroundColor => _themeColors.$2;

  (Color, Color) get _themeColors {
    switch (themeKey) {
      case 'olive':
        return (AppColors.agendaOlive, AppColors.agendaOliveBg);
      case 'brown':
        return (AppColors.agendaBrown, AppColors.agendaBrownBg);
      case 'magenta':
        return (AppColors.agendaMagenta, AppColors.agendaMagentaBg);
      case 'purple':
      default:
        return (AppColors.agendaPurple, AppColors.agendaPurpleBg);
    }
  }

  factory ScheduleEventItem.fromJson(Map<String, dynamic> json) {
    return ScheduleEventItem(
      time: json['time'] as String,
      subject: json['subject'] as String,
      room: json['room'] as String,
      duration: json['duration'] as String,
      themeKey: json['themeKey'] as String? ?? 'purple',
    );
  }
}
