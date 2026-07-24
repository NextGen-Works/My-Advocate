import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/body_map_widget.dart';
import '../widgets/region_detail_card.dart';
import '../utils/region_data.dart';

class BodyMapScreen extends StatelessWidget {
  const BodyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Map'),
        centerTitle: true,
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              final hasPain = provider.currentViewRegions.any((r) => r.painLevel != null);
              if (!hasPain) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear all',
                onPressed: () => provider.clearAssessment(),
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
              children: [
                _ViewToggle(provider: provider, theme: theme),
                const SizedBox(height: 16),
                _Legend(theme: theme),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: theme.colorScheme.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: BodyMapWidget(
                        showBack: provider.showBackView,
                        regions: provider.currentViewRegions,
                        selectedRegionId: provider.selectedRegionId,
                        onRegionTap: (id) {
                          provider.selectRegion(id);
                          _showPainBottomSheet(context, provider, id);
                        },
                      ),
                    ),
                  ),
                ),
                if (provider.selectedRegion != null) ...[
                  const SizedBox(height: 16),
                  RegionDetailCard(
                    region: provider.selectedRegion!,
                    specialties: RegionData.getSpecialtiesForRegion(
                        provider.selectedRegion!.id),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPainBottomSheet(BuildContext context, AppProvider provider, String regionId) {
    final region = RegionData.findById(regionId);
    if (region == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return _PainBottomSheet(
          regionName: region.name,
          initialLevel: region.painLevel ?? 0,
          onSetLevel: (level) {
            provider.setPainLevel(level);
            Navigator.pop(ctx);
          },
        );
      },
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final AppProvider provider;
  final ThemeData theme;
  const _ViewToggle({required this.provider, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            label: 'Front',
            icon: Icons.person,
            selected: !provider.showBackView,
            onTap: () {
              if (provider.showBackView) provider.toggleView();
            },
          ),
          const SizedBox(width: 4),
          _ToggleButton(
            label: 'Back',
            icon: Icons.person_outline,
            selected: provider.showBackView,
            onTap: () {
              if (!provider.showBackView) provider.toggleView();
            },
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18,
                color: selected ? Theme.of(context).colorScheme.onPrimary : null),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Theme.of(context).colorScheme.onPrimary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final ThemeData theme;
  const _Legend({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: const Color(0xFF4CAF50), label: 'Mild (0-2)'),
        const SizedBox(width: 12),
        _LegendItem(color: const Color(0xFFFFEB3B), label: 'Mod (3-4)'),
        const SizedBox(width: 12),
        _LegendItem(color: const Color(0xFFFF9800), label: 'Sev (5-7)'),
        const SizedBox(width: 12),
        _LegendItem(color: const Color(0xFFF44336), label: 'V.Sev (8-10)'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _PainBottomSheet extends StatefulWidget {
  final String regionName;
  final int initialLevel;
  final ValueChanged<int> onSetLevel;

  const _PainBottomSheet({
    required this.regionName,
    required this.initialLevel,
    required this.onSetLevel,
  });

  @override
  State<_PainBottomSheet> createState() => _PainBottomSheetState();
}

class _PainBottomSheetState extends State<_PainBottomSheet> {
  late int _level;

  @override
  void initState() {
    super.initState();
    _level = widget.initialLevel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(widget.regionName,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('How much pain are you experiencing?',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          _LevelSelector(level: _level, onChanged: (v) => setState(() => _level = v)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => widget.onSetLevel(_level),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Set Pain Level'),
          ),
        ],
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  final int level;
  final ValueChanged<int> onChanged;

  const _LevelSelector({required this.level, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(11, (i) {
        final selected = i == level;
        final color = _getColor(i);
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: selected ? 36 : 28,
            height: selected ? 36 : 28,
            decoration: BoxDecoration(
              color: selected ? color : color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? color : color.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                '$i',
                style: TextStyle(
                  color: selected ? Colors.white : color,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: selected ? 13 : 11,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getColor(int level) {
    if (level <= 2) return const Color(0xFF4CAF50);
    if (level <= 4) return const Color(0xFFFFEB3B);
    if (level <= 7) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
