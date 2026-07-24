import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/api_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ApiSection(provider: provider, theme: theme),
              const SizedBox(height: 24),
              _ModelMappingSection(provider: provider, theme: theme),
              const SizedBox(height: 24),
              _DataSection(provider: provider, theme: theme),
              const SizedBox(height: 24),
              _AboutSection(theme: theme),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _ApiSection extends StatefulWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _ApiSection({required this.provider, required this.theme});

  @override
  State<_ApiSection> createState() => _ApiSectionState();
}

class _ApiSectionState extends State<_ApiSection> {
  late TextEditingController _controller;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.provider.apiSettings.endpoint);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: widget.theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.api, color: widget.theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('API Configuration',
                    style: widget.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                const Spacer(),
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.provider.apiSettings.connected
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.provider.apiSettings.connected ? 'Connected' : 'Not Connected',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.provider.apiSettings.connected
                        ? Colors.green
                        : widget.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'API Endpoint',
                hintText: 'http://localhost:1234/v1',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.restore),
                  tooltip: 'Reset to default',
                  onPressed: () {
                    _controller.text = 'http://localhost:1234/v1';
                    widget.provider.setEndpoint('http://localhost:1234/v1');
                  },
                ),
              ),
              onChanged: (v) => widget.provider.setEndpoint(v),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _testing ? null : () async {
                  setState(() => _testing = true);
                  await widget.provider.testApiConnection();
                  await widget.provider.saveSettings();
                  setState(() => _testing = false);
                },
                icon: _testing
                    ? const SizedBox(
                        width: 14, height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.wifi_tethering),
                label: Text(_testing ? 'Testing...' : 'Test Connection'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelMappingSection extends StatefulWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _ModelMappingSection({required this.provider, required this.theme});

  @override
  State<_ModelMappingSection> createState() => _ModelMappingSectionState();
}

class _ModelMappingSectionState extends State<_ModelMappingSection> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    for (final id in ApiSettings.specialtyIds) {
      _controllers[id] = TextEditingController(
        text: widget.provider.apiSettings.modelMapping[id] ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: widget.theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.model_training, color: widget.theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Model Mapping',
                    style: widget.theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Assign LLM models to each specialty',
              style: TextStyle(
                fontSize: 12,
                color: widget.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...ApiSettings.specialtyIds.map((id) {
              final name = _getSpecialtyName(id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllers[id],
                  decoration: InputDecoration(
                    labelText: name,
                    hintText: 'e.g., mistral-7b',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    isDense: true,
                  ),
                  onChanged: (v) {
                    widget.provider.setModelForSpecialty(id, v);
                    widget.provider.saveSettings();
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getSpecialtyName(String id) {
    const names = {
      'primary_care': 'Primary Care',
      'internal_medicine': 'Internal Medicine',
      'orthopedics': 'Orthopedics',
      'rheumatology': 'Rheumatology',
      'neurology': 'Neurology',
      'pain_medicine': 'Pain Medicine',
      'gastroenterology': 'Gastroenterology',
      'cardiology': 'Cardiology',
      'urology': 'Urology',
      'gynecology': 'Gynecology',
      'pmr': 'PM&R',
      'emergency': 'Emergency Medicine',
      'dermatology': 'Dermatology',
      'oncology': 'Oncology',
      'psychiatry': 'Psychiatry',
      'endocrinology': 'Endocrinology',
      'podiatry': 'Podiatry',
      'dentistry': 'Dentistry',
      'pulmonology': 'Pulmonology',
      'general_surgery': 'General Surgery',
    };
    return names[id] ?? id;
  }
}

class _DataSection extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _DataSection({required this.provider, required this.theme});

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
                Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text('Data',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear Assessment'),
                      content: const Text('This will clear all current pain assessment data.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.clearAssessment();
                            Navigator.pop(ctx);
                          },
                          child: const Text('Clear', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Current Assessment'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final ThemeData theme;
  const _AboutSection({required this.theme});

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
                Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('About',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text('My Advocate v1.0.0',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(
              'Clinical decision support tool for pain assessment and medical specialty routing. '
              'Powered by LM Studio local LLM inference.',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Text(
              'Privacy-first: All data is processed locally. No data is sent to external servers.',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
