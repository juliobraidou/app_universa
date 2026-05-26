import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class BoletimHeader extends StatelessWidget {
  final VoidCallback onInfoTap;
  final double iraValue;
  final double iraMax;
  final double iraProgress;

  const BoletimHeader({
    super.key,
    required this.onInfoTap,
    this.iraValue = 7.5,
    this.iraMax = 10,
    this.iraProgress = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.headerBg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Boletim',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: onInfoTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accentPurple.withValues(alpha: 0.6),
                    ),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.iraCardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'IRA Acumulado',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.accentPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${iraValue.toStringAsFixed(1).replaceAll('.', ',')} / ${iraMax.toInt()}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: iraProgress,
                    minHeight: 6,
                    backgroundColor: AppColors.iraProgressBg,
                    color: AppColors.accentPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
