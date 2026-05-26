import '../widgets/grade_card.dart';

class GradeItem {
  final String subject;
  final String professor;
  final double finalGrade;
  final List<ExamGrade> exams;

  const GradeItem({
    required this.subject,
    required this.professor,
    required this.finalGrade,
    required this.exams,
  });

  factory GradeItem.fromJson(Map<String, dynamic> json) {
    final examsJson = json['exams'] as List<dynamic>? ?? [];
    return GradeItem(
      subject: json['subject'] as String,
      professor: json['professor'] as String,
      finalGrade: (json['finalGrade'] as num).toDouble(),
      exams: examsJson
          .map(
            (e) => ExamGrade(
              label: (e as Map<String, dynamic>)['label'] as String,
              value: e['value'] == null ? null : (e['value'] as num).toDouble(),
            ),
          )
          .toList(),
    );
  }
}
