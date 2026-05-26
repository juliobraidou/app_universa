import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class ExamGrade {
  final String label;
  final double? value;

  const ExamGrade({required this.label, this.value});
}

class GradeCard extends StatelessWidget {
  final String subject;
  final String professor;
  final double finalGrade;
  final List<ExamGrade> exams;

  const GradeCard({
    super.key,
    required this.subject,
    required this.professor,
    required this.finalGrade,
    required this.exams,
  });

  (Color bg, Color text) _gradeColors(double? grade) {
    if (grade == null) {
      return (AppColors.gradePending, AppColors.gradePendingText);
    }
    if (grade >= 7) {
      return (AppColors.gradeGreen, AppColors.gradeGreenText);
    }
    if (grade >= 6) {
      return (AppColors.gradeYellow, AppColors.gradeYellowText);
    }
    return (AppColors.gradeRed, AppColors.gradeRedText);
  }

  Widget _badge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (finalBg, finalText) = _gradeColors(finalGrade);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      professor,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: finalBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  finalGrade.toStringAsFixed(1).replaceAll('.', ','),
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: finalText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exams.map((exam) {
              final (bg, text) = _gradeColors(exam.value);
              final label = exam.value != null
                  ? '${exam.label}: ${exam.value!.toStringAsFixed(1).replaceAll('.', ',')}'
                  : '${exam.label}:';
              return _badge(label, bg, text);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
