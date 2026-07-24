import 'package:flutter/material.dart';
import '../models/body_region.dart';
import '../models/medical_specialty.dart';

class RegionDetailCard extends StatelessWidget {
  final BodyRegion region;
  final List<MedicalSpecialty> specialties;

  const RegionDetailCard({
    super.key,
    required this.region,
    required this.specialties,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(region.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
                ),
                if (region.painLevel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: region.painBorderColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: region.painBorderColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${region.painLevel}/10',
                      style: TextStyle(
                        color: region.painBorderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
            if (region.painLevel != null) ...[
              const SizedBox(height: 4),
              Text(region.painLabel,
                  style: TextStyle(color: region.painBorderColor, fontSize: 12)),
            ],
            const SizedBox(height: 12),
            Text('Common Conditions:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                )),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: region.commonConditions.map((c) => Chip(
                label: Text(c, style: const TextStyle(fontSize: 11)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              )).toList(),
            ),
            if (specialties.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Recommended Specialties:',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: specialties.map((s) => Chip(
                  label: Text(s.name, style: const TextStyle(fontSize: 11)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
