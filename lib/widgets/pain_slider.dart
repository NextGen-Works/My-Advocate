import 'package:flutter/material.dart';

class PainSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const PainSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(value);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('No Pain', style: theme.textTheme.bodySmall),
            Text(
              '$value/10',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text('Worst Pain', style: theme.textTheme.bodySmall),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            overlayColor: color.withValues(alpha: 0.12),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mild', style: TextStyle(color: _getColor(2), fontSize: 11)),
            Text('Moderate', style: TextStyle(color: _getColor(5), fontSize: 11)),
            Text('Severe', style: TextStyle(color: _getColor(8), fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Color _getColor(int level) {
    if (level <= 2) return const Color(0xFF4CAF50);
    if (level <= 4) return const Color(0xFFFFEB3B);
    if (level <= 7) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
