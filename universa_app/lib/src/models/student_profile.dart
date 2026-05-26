class StudentProfile {
  final int id;
  final String fullName;
  final String firstName;
  final String avatarInitials;
  final String semesterLabel;
  final String course;
  final String ra;
  final String email;
  final String period;
  final String shift;
  final String entryYear;
  final String universityName;
  final String cardTitle;
  final String cardValidUntilLabel;
  final bool cardIsValid;
  final String cardStatusLabel;

  const StudentProfile({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.avatarInitials,
    required this.semesterLabel,
    required this.course,
    required this.ra,
    required this.email,
    required this.period,
    required this.shift,
    required this.entryYear,
    required this.universityName,
    required this.cardTitle,
    required this.cardValidUntilLabel,
    required this.cardIsValid,
    required this.cardStatusLabel,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      firstName: json['firstName'] as String,
      avatarInitials: json['avatarInitials'] as String,
      semesterLabel: json['semesterLabel'] as String,
      course: json['course'] as String,
      ra: json['ra'] as String,
      email: json['email'] as String? ?? '',
      period: json['period'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
      entryYear: json['entryYear'] as String? ?? '',
      universityName: json['universityName'] as String? ?? 'Universidade Federal',
      cardTitle: json['cardTitle'] as String? ?? 'Carteira de Estudante',
      cardValidUntilLabel: json['cardValidUntilLabel'] as String? ?? '',
      cardIsValid: json['cardIsValid'] as bool? ?? true,
      cardStatusLabel: json['cardStatusLabel'] as String? ?? 'VALIDA',
    );
  }
}
