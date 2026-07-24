import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'body_map_screen.dart';
import 'diagnosis_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Advocate'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final hasRegion = provider.selectedRegion != null;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(theme: theme),
                const SizedBox(height: 24),
                _FeatureGrid(theme: theme, hasRegion: hasRegion),
                if (hasRegion) ...[
                  const SizedBox(height: 24),
                  _DiagnosisButton(theme: theme),
                ],
                const SizedBox(height: 12),
                _DisclaimerText(theme: theme),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ThemeData theme;
  const _HeaderCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.healing, size: 48, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(height: 12),
            Text('Welcome to My Advocate',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                )),
            const SizedBox(height: 8),
            Text(
              'Tap the body map to identify your pain areas,\nassess your symptoms, and get specialty recommendations.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final ThemeData theme;
  final bool hasRegion;
  const _FeatureGrid({required this.theme, required this.hasRegion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureCard(
          icon: Icons.person_outline,
          title: 'Body Map',
          subtitle: hasRegion ? 'Tap to change region' : 'Tap to select pain area',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BodyMapScreen()),
          ),
          theme: theme,
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.assignment_outlined,
          title: 'Pain Assessment',
          subtitle: 'Describe your pain in detail',
          onTap: hasRegion
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiagnosisScreen()),
                  )
              : null,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.local_hospital_outlined,
          title: 'Specialty Routing',
          subtitle: hasRegion ? 'View recommended specialists' : 'Select a region first',
          onTap: hasRegion
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiagnosisScreen()),
                  )
              : null,
          theme: theme,
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final ThemeData theme;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _DiagnosisButton extends StatelessWidget {
  final ThemeData theme;
  const _DiagnosisButton({required this.theme});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DiagnosisScreen()),
      ),
      icon: const Icon(Icons.summarize_outlined),
      label: const Text('View Full Diagnosis'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _DisclaimerText extends StatelessWidget {
  final ThemeData theme;
  const _DisclaimerText({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      'This app provides informational recommendations only.\nAlways consult a qualified healthcare professional.',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
