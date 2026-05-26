import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AttendanceItem {
  final String subject;
  final String professor;
  final int percent;
  final String status;
  final int presencas;
  final int faltas;
  final int aulas;

  const AttendanceItem({
    required this.subject,
    required this.professor,
    required this.percent,
    required this.status,
    required this.presencas,
    required this.faltas,
    required this.aulas,
  });

  Color get statusColor {
    if (percent >= 75) return AppColors.freqGreen;
    if (percent >= 60) return AppColors.freqYellow;
    return AppColors.freqRed;
  }

  factory AttendanceItem.fromJson(Map<String, dynamic> json) {
    return AttendanceItem(
      subject: json['subject'] as String,
      professor: json['professor'] as String,
      percent: json['percent'] as int,
      status: json['status'] as String,
      presencas: json['presencas'] as int,
      faltas: json['faltas'] as int,
      aulas: json['aulas'] as int,
    );
  }
}
