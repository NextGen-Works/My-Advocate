class PainAssessment {
  int intensity;
  String category;
  final Set<String> descriptors;
  DateTime? startDate;
  String trigger;
  String notes;
  String selectedRegionId;
  String selectedRegionName;

  PainAssessment({
    this.intensity = 0,
    this.category = '',
    Set<String>? descriptors,
    this.startDate,
    this.trigger = '',
    this.notes = '',
    this.selectedRegionId = '',
    this.selectedRegionName = '',
  }) : descriptors = descriptors ?? {};

  static const List<String> categories = [
    'Nociceptive',
    'Neuropathic',
    'Nociplastic',
    'Inflammatory',
    'Acute',
    'Chronic',
    'Primary',
  ];

  static const Map<String, String> categoryDescriptions = {
    'Nociceptive': 'Pain from tissue damage (e.g., cut, fracture)',
    'Neuropathic': 'Pain from nerve damage or dysfunction',
    'Nociplastic': 'Pain without clear tissue or nerve damage',
    'Inflammatory': 'Pain from inflammation',
    'Acute': 'Sudden onset, short duration pain',
    'Chronic': 'Persistent pain lasting >3 months',
    'Primary': 'Pain as a primary health condition',
  };

  static const List<String> descriptorList = [
    'Aching', 'Burning', 'Sharp', 'Stabbing', 'Tingling',
    'Throbbing', 'Shooting', 'Gnawing', 'Cramping', 'Electric',
    'Pulling', 'Piercing', 'Dull', 'Splitting', 'Pressing',
    'Cutting', 'Numbing', 'Radiating', 'Deep',
  ];

  Map<String, dynamic> toJson() => {
        'intensity': intensity,
        'category': category,
        'descriptors': descriptors.toList(),
        'startDate': startDate?.toIso8601String(),
        'trigger': trigger,
        'notes': notes,
        'regionId': selectedRegionId,
        'regionName': selectedRegionName,
      };

  String get categoryDescription => categoryDescriptions[category] ?? '';
}
