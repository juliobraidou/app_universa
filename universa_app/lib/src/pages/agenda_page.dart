import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/schedule_event_item.dart';
import '../repositories/schedule_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/agenda_event_card.dart';
import '../widgets/agenda_header.dart';
import '../widgets/agenda_timeline_item.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  static const _weekdaysFull = [
    'DOMINGO',
    'SEGUNDA-FEIRA',
    'TERÇA-FEIRA',
    'QUARTA-FEIRA',
    'QUINTA-FEIRA',
    'SEXTA-FEIRA',
    'SÁBADO',
  ];

  static const _monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static const _monthNamesUpper = [
    'JANEIRO',
    'FEVEREIRO',
    'MARÇO',
    'ABRIL',
    'MAIO',
    'JUNHO',
    'JULHO',
    'AGOSTO',
    'SETEMBRO',
    'OUTUBRO',
    'NOVEMBRO',
    'DEZEMBRO',
  ];

  List<ScheduleEventItem> _events = [];
  bool _loadingEvents = false;
  String? _eventsError;

  late DateTime _focusedMonth;
  late final DateTime _minMonth;
  late final DateTime _today;
  late List<AgendaDayItem> _monthDays;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _minMonth = DateTime(now.year, now.month);
    _focusedMonth = _minMonth;
    _monthDays = _buildMonthDays(_focusedMonth);
    _selectedDayIndex = _defaultSelectedIndex();
    _loadEventsForSelectedDay();
  }

  DateTime get _selectedDate => _monthDays[_selectedDayIndex].date;

  Future<void> _loadEventsForSelectedDay() async {
    if (!_monthDays[_selectedDayIndex].enabled) return;
    setState(() {
      _loadingEvents = true;
      _eventsError = null;
    });
    try {
      final events = await context
          .read<ScheduleRepository>()
          .getByDate(_selectedDate);
      if (!mounted) return;
      setState(() {
        _events = events;
        _loadingEvents = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _eventsError = e.toString().replaceFirst('Exception: ', '');
        _loadingEvents = false;
      });
    }
  }

  int _monthKey(DateTime date) => date.year * 12 + date.month;

  bool get _canGoPreviousMonth =>
      _monthKey(_focusedMonth) > _monthKey(_minMonth);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isDayEnabled(DateTime date, DateTime focusedMonth) {
    if (date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday) {
      return false;
    }

    if (date.month != focusedMonth.month || date.year != focusedMonth.year) {
      return false;
    }

    if (_monthKey(focusedMonth) == _monthKey(_minMonth)) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (dateOnly.isBefore(_today)) return false;
    }

    return true;
  }

  List<AgendaDayItem> _buildMonthDays(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0).day;

    return List.generate(lastDay, (index) {
      final date = DateTime(month.year, month.month, index + 1);
      final enabled = _isDayEnabled(date, month);

      return AgendaDayItem(
        date: date,
        enabled: enabled,
        showDot: enabled,
      );
    });
  }

  int _defaultSelectedIndex() {
    final todayIndex = _monthDays.indexWhere(
      (day) => day.enabled && _isSameDay(day.date, _today),
    );
    if (todayIndex >= 0) return todayIndex;

    final firstEnabled = _monthDays.indexWhere((day) => day.enabled);
    return firstEnabled >= 0 ? firstEnabled : 0;
  }

  int _firstEnabledDayIndex() {
    final index = _monthDays.indexWhere((day) => day.enabled);
    return index >= 0 ? index : 0;
  }

  void _previousMonth() {
    if (!_canGoPreviousMonth) return;
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      _monthDays = _buildMonthDays(_focusedMonth);
      _selectedDayIndex = _firstEnabledDayIndex();
    });
    _loadEventsForSelectedDay();
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      _monthDays = _buildMonthDays(_focusedMonth);
      _selectedDayIndex = _firstEnabledDayIndex();
    });
    _loadEventsForSelectedDay();
  }

  String get _monthYearLabel {
    return '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  String get _dateLabel {
    final selected = _monthDays[_selectedDayIndex];
    final weekdayIndex =
        selected.date.weekday == DateTime.sunday ? 0 : selected.date.weekday;
    final weekday = _weekdaysFull[weekdayIndex];
    final monthName = _monthNamesUpper[selected.date.month - 1];
    return '$weekday, ${selected.date.day} DE $monthName';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgendaHeader(
          monthYear: _monthYearLabel,
          days: _monthDays,
          selectedIndex: _selectedDayIndex,
          canGoPreviousMonth: _canGoPreviousMonth,
          canGoNextMonth: true,
          onPreviousMonth: _previousMonth,
          onNextMonth: _nextMonth,
          onDaySelected: (index) {
            if (_monthDays[index].enabled) {
              setState(() => _selectedDayIndex = index);
              _loadEventsForSelectedDay();
            }
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dateLabel,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sectionTitle,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 20),
                if (_loadingEvents)
                  const Center(child: CircularProgressIndicator())
                else if (_eventsError != null)
                  Column(
                    children: [
                      Text(_eventsError!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _loadEventsForSelectedDay,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  )
                else if (_events.isEmpty)
                  Text(
                    'Nenhum evento neste dia',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.sectionTitle,
                    ),
                  )
                else
                  ...List.generate(_events.length, (index) {
                    final event = _events[index];
                    return AgendaTimelineItem(
                      time: event.time,
                      dotColor: event.accentColor,
                      isLast: index == _events.length - 1,
                      card: AgendaEventCard(
                        subject: event.subject,
                        room: event.room,
                        duration: event.duration,
                        accentColor: event.accentColor,
                        backgroundColor: event.backgroundColor,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
