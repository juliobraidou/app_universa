import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'custom_button.dart';
import 'percent_ring.dart';

class IraToolkitSheet extends StatelessWidget {
  const IraToolkitSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const IraToolkitSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.classCardBorder,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
                    Text(
                      'O que é IRA?',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Índice de Rendimento Acadêmico',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: PercentRing(
                        size: 140,
                        strokeWidth: 10,
                        value: 0.75,
                        color: AppColors.toolkitPurple,
                        backgroundColor: AppColors.iconBoxPurple,
                        center: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '7,5',
                              style: GoogleFonts.roboto(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              '/ 10',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Bom desempenho',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.toolkitPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'O IRA representa sua média geral acadêmica durante o curso.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.classCardBorder),
                    const SizedBox(height: 24),
                    Text(
                      'Como o IRA é calculado?',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: _ToolkitFactor(icon: Icons.menu_book, label: 'Notas', desc: 'Desempenho nas disciplinas')),
                        SizedBox(width: 8),
                        Expanded(child: _ToolkitFactor(icon: Icons.event_available, label: 'Frequência', desc: 'Presença nas aulas')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Expanded(child: _ToolkitFactor(icon: Icons.schedule, label: 'Carga horária', desc: 'Horas cursadas')),
                        SizedBox(width: 8),
                        Expanded(child: _ToolkitFactor(icon: Icons.bar_chart, label: 'Desempenho', desc: 'Rendimento geral')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Escala de IRA',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Entenda sua faixa de desempenho:',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _IraScaleBar(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.iconBoxPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 18,
                              color: AppColors.toolkitPurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Quanto maior o IRA, melhor seu desempenho acadêmico ao longo do curso.',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: AppColors.toolkitPurple, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Seu progresso',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.iconBoxPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.show_chart,
                              size: 20,
                              color: AppColors.toolkitPurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Você melhorou 0,3 pontos nos últimos 30 dias.',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gradeGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+0,3 ↗',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gradeGreenText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
            CustomButton(
              title: 'Entendi',
              color: AppColors.toolkitPurple,
              titleColor: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolkitFactor extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;

  const _ToolkitFactor({
    required this.icon,
    required this.label,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.iconBoxPurple,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.toolkitPurple),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          desc,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _IraScaleBar extends StatelessWidget {
  const _IraScaleBar();

  @override
  Widget build(BuildContext context) {
    const segments = [
      AppColors.gradeRed,
      Color(0xFFFF9800),
      AppColors.gradeYellow,
      AppColors.gradeGreen,
      AppColors.freqGreen,
      AppColors.accentPurple,
      AppColors.toolkitPurple,
    ];

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: segments
                .map((c) => Expanded(child: Container(height: 8, color: c)))
                .toList(),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['0', '4', '5', '6', '7', '8', '9', '10']
              .map(
                (n) => Text(
                  n,
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Baixo', style: _labelStyle(AppColors.gradeRedText)),
            Text('Regular', style: _labelStyle(const Color(0xFFFF9800))),
            Text('Bom', style: _labelStyle(AppColors.gradeGreenText)),
            Text('Excelente', style: _labelStyle(AppColors.toolkitPurple)),
          ],
        ),
      ],
    );
  }

  TextStyle _labelStyle(Color color) {
    return GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w600, color: color);
  }
}
