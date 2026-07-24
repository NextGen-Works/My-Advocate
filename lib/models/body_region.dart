import 'package:flutter/material.dart';

class BodyRegion {
  final String id;
  final String name;
  final String side;
  final String view;
  final List<String> specialties;
  final List<String> commonConditions;
  int? painLevel;

  BodyRegion({
    required this.id,
    required this.name,
    required this.side,
    required this.view,
    required this.specialties,
    required this.commonConditions,
    this.painLevel,
  });

  Color get painColor {
    if (painLevel == null) return Colors.transparent;
    if (painLevel! <= 2) return const Color(0x4400E676);
    if (painLevel! <= 4) return const Color(0x44FFEB3B);
    if (painLevel! <= 7) return const Color(0x44FF9800);
    return const Color(0x44F44336);
  }

  Color get painBorderColor {
    if (painLevel == null) return Colors.transparent;
    if (painLevel! <= 2) return const Color(0xFF00E676);
    if (painLevel! <= 4) return const Color(0xFFFFEB3B);
    if (painLevel! <= 7) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String get painLabel {
    if (painLevel == null) return '';
    if (painLevel! <= 2) return 'Mild';
    if (painLevel! <= 4) return 'Moderate';
    if (painLevel! <= 7) return 'Severe';
    return 'Very Severe';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'painLevel': painLevel,
      };
}
