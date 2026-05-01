import 'package:flutter/material.dart';

enum ApplicationStatus {
  applied('Başvuruldu', '📥', Color(0xFF6366F1)),
  underReview('İnceleniyor', '👀', Color(0xFF8B5CF6)),
  assessment('Değerlendirme/Test', '📝', Color(0xFFF59E0B)),
  interview('Mülakat Aşaması', '🎙️', Color(0xFF0EA5E9)),
  hired('Kabul Edildi', '✅', Color(0xFF059669)),
  rejected('Reddedildi', '❌', Color(0xFFEF4444)),
  withdrawn('Geri Çekildi', '🔙', Color(0xFF6B7280));

  final String label;
  final String emoji;
  final Color color;

  const ApplicationStatus(this.label, this.emoji, this.color);

  factory ApplicationStatus.fromString(String? status) {
    if (status == null) return ApplicationStatus.applied;
    return ApplicationStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase() || e.toString().toLowerCase() == status.toLowerCase(),
      orElse: () => ApplicationStatus.applied,
    );
  }
}
