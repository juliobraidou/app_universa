import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/academic_summary.dart';
import '../models/attendance_item.dart';
import '../models/grade_item.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/grades_repository.dart';
import '../repositories/student_repository.dart';
import '../widgets/boletim_header.dart';
import '../widgets/frequency_card.dart';
import '../widgets/grade_card.dart';
import '../widgets/ira_toolkit_sheet.dart';
import '../widgets/segment_tab_bar.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  int _tabIndex = 0;
  bool _loading = true;
  String? _error;
  List<GradeItem> _grades = [];
  List<AttendanceItem> _attendance = [];
  double _ira = 7.5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final gradesRepo = context.read<GradesRepository>();
      final attendanceRepo = context.read<AttendanceRepository>();
      final studentRepo = context.read<StudentRepository>();

      final results = await Future.wait([
        gradesRepo.getGrades(),
        attendanceRepo.getAttendance(),
        studentRepo.getSummary(),
      ]);

      if (!mounted) return;
      setState(() {
        _grades = results[0] as List<GradeItem>;
        _attendance = results[1] as List<AttendanceItem>;
        _ira = (results[2] as AcademicSummary).ira;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoletimHeader(
          onInfoTap: () => IraToolkitSheet.show(context),
          iraValue: _ira,
          iraProgress: _ira / 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: SegmentTabBar(
            tabs: const ['NOTAS', 'FREQUENCIA'],
            selectedIndex: _tabIndex,
            onChanged: (index) => setState(() => _tabIndex = index),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _load, child: const Text('Tentar novamente')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: _tabIndex == 0 ? _buildGradesList() : _buildFrequencyList(),
    );
  }

  Widget _buildGradesList() {
    return Column(
      children: _grades
          .map(
            (item) => GradeCard(
              subject: item.subject,
              professor: item.professor,
              finalGrade: item.finalGrade,
              exams: item.exams,
            ),
          )
          .toList(),
    );
  }

  Widget _buildFrequencyList() {
    return Column(
      children: _attendance
          .map(
            (item) => FrequencyCard(
              subject: item.subject,
              professor: item.professor,
              percent: item.percent,
              statusLabel: item.status,
              statusColor: item.statusColor,
              presencas: item.presencas,
              faltas: item.faltas,
              aulas: item.aulas,
            ),
          )
          .toList(),
    );
  }
}
