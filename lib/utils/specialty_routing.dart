import '../models/pain_assessment.dart';
import '../models/medical_specialty.dart';
import 'region_data.dart';

class SpecialtyRouting {
  static List<MedicalSpecialty> route(PainAssessment assessment) {
    final region = RegionData.findById(assessment.selectedRegionId);
    if (region == null) return [];

    final matchedSpecialties = <String, int>{};

    for (final specId in region.specialties) {
      matchedSpecialties[specId] = (matchedSpecialties[specId] ?? 0) + 1;
    }

    if (assessment.category == 'Neuropathic') {
      matchedSpecialties['neurology'] = (matchedSpecialties['neurology'] ?? 0) + 2;
    }
    if (assessment.category == 'Inflammatory') {
      matchedSpecialties['rheumatology'] = (matchedSpecialties['rheumatology'] ?? 0) + 2;
    }
    if (assessment.category == 'Acute') {
      matchedSpecialties['emergency'] = (matchedSpecialties['emergency'] ?? 0) + 2;
    }

    if (assessment.intensity >= 8) {
      matchedSpecialties['emergency'] = (matchedSpecialties['emergency'] ?? 0) + 1;
      matchedSpecialties['pain_medicine'] = (matchedSpecialties['pain_medicine'] ?? 0) + 1;
    }

    if (assessment.descriptors.any((d) =>
        ['Burning', 'Electric', 'Shooting', 'Tingling', 'Numbing'].contains(d))) {
      matchedSpecialties['neurology'] = (matchedSpecialties['neurology'] ?? 0) + 2;
    }

    if (assessment.descriptors.contains('Aching') &&
        (assessment.category == 'Chronic' || assessment.category == 'Primary')) {
      matchedSpecialties['rheumatology'] = (matchedSpecialties['rheumatology'] ?? 0) + 1;
      matchedSpecialties['pain_medicine'] = (matchedSpecialties['pain_medicine'] ?? 0) + 1;
    }

    final sortedEntries = matchedSpecialties.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .map((e) => MedicalSpecialty.findById(e.key))
        .whereType<MedicalSpecialty>()
        .toList();
  }
}
