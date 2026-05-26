class UpcomingClass {
  final String time;
  final String course;
  final String location;

  const UpcomingClass({
    required this.time,
    required this.course,
    required this.location,
  });

  factory UpcomingClass.fromJson(Map<String, dynamic> json) {
    return UpcomingClass(
      time: json['time'] as String,
      course: json['course'] as String,
      location: json['location'] as String,
    );
  }
}

class AcademicSummary {
  final double ira;
  final int subjectsCount;
  final int examsCount;
  final int attendancePercent;
  final List<UpcomingClass> upcomingClasses;

  const AcademicSummary({
    required this.ira,
    required this.subjectsCount,
    required this.examsCount,
    required this.attendancePercent,
    required this.upcomingClasses,
  });

  factory AcademicSummary.fromJson(Map<String, dynamic> json) {
    final classes = (json['upcomingClasses'] as List<dynamic>? ?? [])
        .map((e) => UpcomingClass.fromJson(e as Map<String, dynamic>))
        .toList();

    return AcademicSummary(
      ira: (json['ira'] as num).toDouble(),
      subjectsCount: json['subjectsCount'] as int,
      examsCount: json['examsCount'] as int,
      attendancePercent: json['attendancePercent'] as int,
      upcomingClasses: classes,
    );
  }
}
