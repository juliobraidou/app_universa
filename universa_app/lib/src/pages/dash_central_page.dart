import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/academic_summary.dart';
import '../repositories/student_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/class_card.dart';
import '../widgets/summary_card.dart';

class DashCentralContent extends StatefulWidget {
  const DashCentralContent({super.key});

  @override
  State<DashCentralContent> createState() => _DashCentralContentState();
}

class _DashCentralContentState extends State<DashCentralContent> {
  AcademicSummary? _summary;
  bool _loading = true;
  String? _error;

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
      final summary =
          await context.read<StudentRepository>().getSummary();
      if (!mounted) return;
      setState(() {
        _summary = summary;
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Tentar novamente')),
            ],
          ),
        ),
      );
    }

    final summary = _summary!;
    final summaryItems = [
      (icon: Icons.show_chart, value: summary.ira.toStringAsFixed(1).replaceAll('.', ','), label: 'IRA'),
      (icon: Icons.menu_book, value: '${summary.subjectsCount}', label: 'MATERIAS'),
      (icon: Icons.calendar_today, value: '${summary.examsCount}', label: 'PROVAS'),
      (icon: Icons.percent, value: '${summary.attendancePercent}%', label: 'FREQUENCIA'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESUMO ACADEMICO',
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.sectionTitle,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: summaryItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = summaryItems[index];
              return SummaryCard(
                icon: item.icon,
                value: item.value,
                label: item.label,
              );
            },
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Text(
                  'PROXIMAS AULAS',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sectionTitle,
                    letterSpacing: 1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'VER AGENDA',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentPurple,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...summary.upcomingClasses.map(
            (item) => ClassCard(
              time: item.time,
              courseName: item.course,
              locationInfo: item.location,
            ),
          ),
        ],
      ),
    );
  }
}
