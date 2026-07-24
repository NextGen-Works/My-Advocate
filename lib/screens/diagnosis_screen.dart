import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../widgets/pain_slider.dart';
import '../models/pain_assessment.dart';

class DiagnosisScreen extends StatelessWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pain Assessment'),
        centerTitle: true,
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Export Report',
                onPressed: () {
                  final report = provider.generateReport();
                  Share.share(report);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _RegionSection(provider: provider, theme: theme),
                const SizedBox(height: 20),
                _IntensitySection(provider: provider, theme: theme),
                const SizedBox(height: 20),
                _CategorySection(provider: provider, theme: theme),
                const SizedBox(height: 20),
                _DescriptorsSection(provider: provider, theme: theme),
                const SizedBox(height: 20),
                _DurationSection(provider: provider, theme: theme),
                const SizedBox(height: 20),
                _TriggerSection(provider: provider, theme: theme),
                const SizedBox(height: 20),
                _NotesSection(provider: provider, theme: theme),
                const SizedBox(height: 24),
                _SpecialtiesSection(provider: provider, theme: theme),
                const SizedBox(height: 24),
                _AiSection(provider: provider, theme: theme),
                const SizedBox(height: 32),
                _Disclaimer(theme: theme),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RegionSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _RegionSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(Icons.location_on, color: theme.colorScheme.primary),
        title: const Text('Selected Body Region', style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(provider.selectedRegion?.name ?? 'None selected'),
      ),
    );
  }
}

class _IntensitySection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _IntensitySection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Pain Intensity',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            PainSlider(
              value: provider.assessment.intensity,
              onChanged: (v) => provider.setPainLevel(v),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _CategorySection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category_outlined, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Pain Category',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PainAssessment.categories.map((cat) {
                final selected = provider.assessment.category == cat;
                return ChoiceChip(
                  label: Text(cat, style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => provider.setPainCategory(cat),
                );
              }).toList(),
            ),
            if (provider.assessment.category.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                provider.assessment.categoryDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DescriptorsSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _DescriptorsSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_snippet_outlined, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Pain Descriptors',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: PainAssessment.descriptorList.map((desc) {
                final selected = provider.assessment.descriptors.contains(desc);
                return FilterChip(
                  label: Text(desc, style: const TextStyle(fontSize: 11)),
                  selected: selected,
                  onSelected: (_) => provider.toggleDescriptor(desc),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _DurationSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
        title: const Text('When did the pain start?',
            style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          provider.assessment.startDate != null
              ?                           provider.assessment.startDate!.toLocal().toString().split(' ')[0]
              : 'Tap to select date',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: provider.assessment.startDate ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (date != null) provider.setStartDate(date);
        },
      ),
    );
  }
}

class _TriggerSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _TriggerSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Trigger / Onset',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'What caused the pain? Injury, activity, or spontaneous...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLow,
              ),
              maxLines: 2,
              onChanged: (v) => provider.setTrigger(v),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _NotesSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notes, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Additional Notes',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Any other details about your pain...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLow,
              ),
              maxLines: 3,
              onChanged: (v) => provider.setNotes(v),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialtiesSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _SpecialtiesSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    final specialties = provider.routedSpecialties;
    if (specialties.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      color: theme.colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: theme.colorScheme.onSecondaryContainer, size: 20),
                const SizedBox(width: 8),
                Text('Recommended Specialties',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSecondaryContainer,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            ...specialties.map((spec) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(spec.name,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(spec.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _AiSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _AiSection({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('AI Consultation',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                if (provider.apiSettings.connected && provider.aiResponse == null)
                  TextButton.icon(
                    onPressed: provider.isLoading ? null : () => provider.getAiConsultation(),
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 14, height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_arrow, size: 18),
                    label: Text(provider.isLoading ? 'Thinking...' : 'Consult AI'),
                  ),
              ],
            ),
            if (!provider.apiSettings.connected) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.wifi_off, size: 18, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'API not connected. Configure in Settings.',
                        style: TextStyle(color: theme.colorScheme.onErrorContainer, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (provider.aiResponse != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(provider.aiResponse!, style: const TextStyle(fontSize: 13)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  final ThemeData theme;
  const _Disclaimer({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber, size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This assessment is for informational purposes only and does not constitute medical advice. Always consult a qualified healthcare professional for diagnosis and treatment.',
              style: TextStyle(fontSize: 11, color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
