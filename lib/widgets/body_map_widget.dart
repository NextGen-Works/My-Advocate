import 'package:flutter/material.dart';
import '../models/body_region.dart';

class BodyRegionTarget {
  final String id;
  final Rect bounds;
  final BodyRegion region;

  BodyRegionTarget({required this.id, required this.bounds, required this.region});
}

class BodyMapWidget extends StatelessWidget {
  final bool showBack;
  final List<BodyRegion> regions;
  final String? selectedRegionId;
  final ValueChanged<String> onRegionTap;

  const BodyMapWidget({
    super.key,
    required this.showBack,
    required this.regions,
    required this.selectedRegionId,
    required this.onRegionTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 1.8;
        final scale = width / 300;

        return GestureDetector(
          onTapDown: (details) => _handleTap(details.localPosition, scale),
          child: CustomPaint(
            size: Size(width, height),
            painter: _BodyPainter(
              showBack: showBack,
              regions: regions,
              selectedRegionId: selectedRegionId,
              scale: scale,
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset position, double scale) {
    for (final region in regions) {
      final target = _getRegionTarget(region, scale);
      if (target != null && target.bounds.contains(position)) {
        onRegionTap(region.id);
        return;
      }
    }
  }

  BodyRegionTarget? _getRegionTarget(BodyRegion region, double scale) {
    final bounds = _regionBounds(region.id, scale);
    if (bounds == null) return null;
    return BodyRegionTarget(id: region.id, bounds: bounds, region: region);
  }

  Rect? _regionBounds(String id, double s) {
    if (showBack) {
      return _backRegionBounds(id, s);
    }
    return _frontRegionBounds(id, s);
  }

  Rect? _frontRegionBounds(String id, double s) {
    switch (id) {
      case 'head_front': return Rect.fromLTWH(110 * s, 5 * s, 80 * s, 50 * s);
      case 'neck_front': return Rect.fromLTWH(125 * s, 55 * s, 50 * s, 30 * s);
      case 'shoulder_left': return Rect.fromLTWH(50 * s, 80 * s, 60 * s, 40 * s);
      case 'shoulder_right': return Rect.fromLTWH(190 * s, 80 * s, 60 * s, 40 * s);
      case 'chest': return Rect.fromLTWH(115 * s, 90 * s, 70 * s, 65 * s);
      case 'upper_arm_left': return Rect.fromLTWH(55 * s, 120 * s, 30 * s, 60 * s);
      case 'upper_arm_right': return Rect.fromLTWH(215 * s, 120 * s, 30 * s, 60 * s);
      case 'elbow_left': return Rect.fromLTWH(45 * s, 178 * s, 35 * s, 22 * s);
      case 'elbow_right': return Rect.fromLTWH(220 * s, 178 * s, 35 * s, 22 * s);
      case 'forearm_left': return Rect.fromLTWH(48 * s, 200 * s, 28 * s, 55 * s);
      case 'forearm_right': return Rect.fromLTWH(224 * s, 200 * s, 28 * s, 55 * s);
      case 'hand_left': return Rect.fromLTWH(45 * s, 252 * s, 25 * s, 30 * s);
      case 'hand_right': return Rect.fromLTWH(230 * s, 252 * s, 25 * s, 30 * s);
      case 'upper_abdomen': return Rect.fromLTWH(120 * s, 155 * s, 60 * s, 45 * s);
      case 'lower_abdomen': return Rect.fromLTWH(120 * s, 200 * s, 60 * s, 45 * s);
      case 'hip_left': return Rect.fromLTWH(80 * s, 240 * s, 35 * s, 25 * s);
      case 'hip_right': return Rect.fromLTWH(185 * s, 240 * s, 35 * s, 25 * s);
      case 'thigh_left_front': return Rect.fromLTWH(90 * s, 270 * s, 40 * s, 70 * s);
      case 'thigh_right_front': return Rect.fromLTWH(170 * s, 270 * s, 40 * s, 70 * s);
      case 'knee_left_front': return Rect.fromLTWH(92 * s, 338 * s, 38 * s, 22 * s);
      case 'knee_right_front': return Rect.fromLTWH(170 * s, 338 * s, 38 * s, 22 * s);
      case 'lower_leg_left_front': return Rect.fromLTWH(95 * s, 360 * s, 30 * s, 60 * s);
      case 'lower_leg_right_front': return Rect.fromLTWH(175 * s, 360 * s, 30 * s, 60 * s);
      case 'foot_left': return Rect.fromLTWH(92 * s, 418 * s, 28 * s, 25 * s);
      case 'foot_right': return Rect.fromLTWH(180 * s, 418 * s, 28 * s, 25 * s);
      default: return null;
    }
  }

  Rect? _backRegionBounds(String id, double s) {
    switch (id) {
      case 'head_back': return Rect.fromLTWH(110 * s, 5 * s, 80 * s, 50 * s);
      case 'neck_back': return Rect.fromLTWH(125 * s, 55 * s, 50 * s, 30 * s);
      case 'shoulder_left_back': return Rect.fromLTWH(50 * s, 80 * s, 60 * s, 40 * s);
      case 'shoulder_right_back': return Rect.fromLTWH(190 * s, 80 * s, 60 * s, 40 * s);
      case 'upper_back': return Rect.fromLTWH(115 * s, 90 * s, 70 * s, 65 * s);
      case 'lower_back': return Rect.fromLTWH(115 * s, 155 * s, 70 * s, 60 * s);
      case 'upper_arm_left_back': return Rect.fromLTWH(55 * s, 120 * s, 30 * s, 60 * s);
      case 'upper_arm_right_back': return Rect.fromLTWH(215 * s, 120 * s, 30 * s, 60 * s);
      case 'elbow_left_back': return Rect.fromLTWH(45 * s, 178 * s, 35 * s, 22 * s);
      case 'elbow_right_back': return Rect.fromLTWH(220 * s, 178 * s, 35 * s, 22 * s);
      case 'forearm_left_back': return Rect.fromLTWH(48 * s, 200 * s, 28 * s, 55 * s);
      case 'forearm_right_back': return Rect.fromLTWH(224 * s, 200 * s, 28 * s, 55 * s);
      case 'hand_left_back': return Rect.fromLTWH(45 * s, 252 * s, 25 * s, 30 * s);
      case 'hand_right_back': return Rect.fromLTWH(230 * s, 252 * s, 25 * s, 30 * s);
      case 'sacrum': return Rect.fromLTWH(120 * s, 210 * s, 60 * s, 35 * s);
      case 'buttock_left': return Rect.fromLTWH(80 * s, 240 * s, 38 * s, 25 * s);
      case 'buttock_right': return Rect.fromLTWH(182 * s, 240 * s, 38 * s, 25 * s);
      case 'thigh_left_back': return Rect.fromLTWH(90 * s, 270 * s, 40 * s, 70 * s);
      case 'thigh_right_back': return Rect.fromLTWH(170 * s, 270 * s, 40 * s, 70 * s);
      case 'knee_left_back': return Rect.fromLTWH(92 * s, 338 * s, 38 * s, 22 * s);
      case 'knee_right_back': return Rect.fromLTWH(170 * s, 338 * s, 38 * s, 22 * s);
      case 'lower_leg_left_back': return Rect.fromLTWH(95 * s, 360 * s, 30 * s, 60 * s);
      case 'lower_leg_right_back': return Rect.fromLTWH(175 * s, 360 * s, 30 * s, 60 * s);
      default: return null;
    }
  }
}

class _BodyPainter extends CustomPainter {
  final bool showBack;
  final List<BodyRegion> regions;
  final String? selectedRegionId;
  final double scale;

  _BodyPainter({
    required this.showBack,
    required this.regions,
    required this.selectedRegionId,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = scale;
    _drawBodyOutline(canvas, s);
    _drawRegions(canvas, s);
  }

  void _drawBodyOutline(Canvas canvas, double s) {
    final paint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(130 * s, 55 * s);
    path.lineTo(130 * s, 55 * s);
    path.addOval(Rect.fromLTWH(110 * s, 2 * s, 80 * s, 55 * s));
    path.moveTo(130 * s, 57 * s);
    path.lineTo(130 * s, 85 * s);
    path.lineTo(95 * s, 85 * s);
    path.quadraticBezierTo(80 * s, 95 * s, 75 * s, 115 * s);
    path.lineTo(55 * s, 115 * s);
    path.lineTo(55 * s, 250 * s);
    path.lineTo(80 * s, 250 * s);
    path.lineTo(80 * s, 115 * s);
    path.moveTo(170 * s, 57 * s);
    path.lineTo(170 * s, 85 * s);
    path.lineTo(205 * s, 85 * s);
    path.quadraticBezierTo(220 * s, 95 * s, 225 * s, 115 * s);
    path.lineTo(245 * s, 115 * s);
    path.lineTo(245 * s, 250 * s);
    path.lineTo(220 * s, 250 * s);
    path.lineTo(220 * s, 115 * s);
    path.moveTo(110 * s, 85 * s);
    path.lineTo(110 * s, 245 * s);
    path.lineTo(90 * s, 265 * s);
    path.lineTo(90 * s, 410 * s);
    path.quadraticBezierTo(90 * s, 420 * s, 100 * s, 425 * s);
    path.lineTo(110 * s, 425 * s);
    path.lineTo(110 * s, 410 * s);
    path.moveTo(190 * s, 85 * s);
    path.lineTo(190 * s, 245 * s);
    path.lineTo(210 * s, 265 * s);
    path.lineTo(210 * s, 410 * s);
    path.quadraticBezierTo(210 * s, 420 * s, 200 * s, 425 * s);
    path.lineTo(190 * s, 425 * s);
    path.lineTo(190 * s, 410 * s);

    if (showBack) {
      _drawBackDetails(canvas, s);
    } else {
      _drawFrontDetails(canvas, s);
    }

    canvas.drawPath(path, paint);
  }

  void _drawFrontDetails(Canvas canvas, double s) {
    final paint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(150 * s, 155 * s), Offset(150 * s, 200 * s), paint);
    canvas.drawLine(Offset(150 * s, 200 * s), Offset(150 * s, 245 * s), paint);
  }

  void _drawBackDetails(Canvas canvas, double s) {
    final paint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(150 * s, 155 * s), Offset(150 * s, 210 * s), paint);
    canvas.drawLine(Offset(150 * s, 210 * s), Offset(150 * s, 240 * s), paint);
  }

  void _drawRegions(Canvas canvas, double s) {
    for (final region in regions) {
      final bounds = _getBounds(region.id, s);
      if (bounds == null) continue;

      final isSelected = region.id == selectedRegionId;
      final hasPain = region.painLevel != null;

      if (hasPain) {
        final fillPaint = Paint()
          ..color = region.painColor
          ..style = PaintingStyle.fill;
        canvas.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(4 * s)), fillPaint);

        final borderPaint = Paint()
          ..color = region.painBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.5 : 1.5;
        canvas.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(4 * s)), borderPaint);
      } else {
        final fillPaint = Paint()
          ..color = isSelected ? const Color(0x3342A5F5) : const Color(0x08000000)
          ..style = PaintingStyle.fill;
        canvas.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(4 * s)), fillPaint);

        final borderPaint = Paint()
          ..color = isSelected ? const Color(0xFF42A5F5) : const Color(0x22000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.0 : 1.0;
        canvas.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(4 * s)), borderPaint);
      }

      if (hasPain && region.painLevel != null) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${region.painLevel}',
            style: TextStyle(
              color: region.painBorderColor,
              fontSize: 10 * s,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(
          bounds.center.dx - textPainter.width / 2,
          bounds.center.dy - textPainter.height / 2,
        ));
      }
    }
  }

  Rect? _getBounds(String id, double s) {
    final list = showBack ? _backBounds(id, s) : _frontBounds(id, s);
    return list;
  }

  Rect? _frontBounds(String id, double s) {
    switch (id) {
      case 'head_front': return Rect.fromLTWH(112 * s, 7 * s, 76 * s, 46 * s);
      case 'neck_front': return Rect.fromLTWH(127 * s, 57 * s, 46 * s, 26 * s);
      case 'shoulder_left': return Rect.fromLTWH(60 * s, 82 * s, 50 * s, 35 * s);
      case 'shoulder_right': return Rect.fromLTWH(190 * s, 82 * s, 50 * s, 35 * s);
      case 'chest': return Rect.fromLTWH(117 * s, 92 * s, 66 * s, 60 * s);
      case 'upper_arm_left': return Rect.fromLTWH(58 * s, 122 * s, 24 * s, 55 * s);
      case 'upper_arm_right': return Rect.fromLTWH(218 * s, 122 * s, 24 * s, 55 * s);
      case 'elbow_left': return Rect.fromLTWH(50 * s, 180 * s, 28 * s, 18 * s);
      case 'elbow_right': return Rect.fromLTWH(222 * s, 180 * s, 28 * s, 18 * s);
      case 'forearm_left': return Rect.fromLTWH(52 * s, 202 * s, 22 * s, 50 * s);
      case 'forearm_right': return Rect.fromLTWH(226 * s, 202 * s, 22 * s, 50 * s);
      case 'hand_left': return Rect.fromLTWH(50 * s, 255 * s, 18 * s, 24 * s);
      case 'hand_right': return Rect.fromLTWH(232 * s, 255 * s, 18 * s, 24 * s);
      case 'upper_abdomen': return Rect.fromLTWH(122 * s, 157 * s, 56 * s, 40 * s);
      case 'lower_abdomen': return Rect.fromLTWH(122 * s, 202 * s, 56 * s, 40 * s);
      case 'hip_left': return Rect.fromLTWH(85 * s, 242 * s, 28 * s, 20 * s);
      case 'hip_right': return Rect.fromLTWH(187 * s, 242 * s, 28 * s, 20 * s);
      case 'thigh_left_front': return Rect.fromLTWH(93 * s, 272 * s, 34 * s, 65 * s);
      case 'thigh_right_front': return Rect.fromLTWH(173 * s, 272 * s, 34 * s, 65 * s);
      case 'knee_left_front': return Rect.fromLTWH(95 * s, 340 * s, 32 * s, 18 * s);
      case 'knee_right_front': return Rect.fromLTWH(173 * s, 340 * s, 32 * s, 18 * s);
      case 'lower_leg_left_front': return Rect.fromLTWH(98 * s, 362 * s, 26 * s, 55 * s);
      case 'lower_leg_right_front': return Rect.fromLTWH(176 * s, 362 * s, 26 * s, 55 * s);
      case 'foot_left': return Rect.fromLTWH(96 * s, 420 * s, 22 * s, 20 * s);
      case 'foot_right': return Rect.fromLTWH(182 * s, 420 * s, 22 * s, 20 * s);
      default: return null;
    }
  }

  Rect? _backBounds(String id, double s) {
    switch (id) {
      case 'head_back': return Rect.fromLTWH(112 * s, 7 * s, 76 * s, 46 * s);
      case 'neck_back': return Rect.fromLTWH(127 * s, 57 * s, 46 * s, 26 * s);
      case 'shoulder_left_back': return Rect.fromLTWH(60 * s, 82 * s, 50 * s, 35 * s);
      case 'shoulder_right_back': return Rect.fromLTWH(190 * s, 82 * s, 50 * s, 35 * s);
      case 'upper_back': return Rect.fromLTWH(117 * s, 92 * s, 66 * s, 60 * s);
      case 'lower_back': return Rect.fromLTWH(117 * s, 157 * s, 66 * s, 55 * s);
      case 'upper_arm_left_back': return Rect.fromLTWH(58 * s, 122 * s, 24 * s, 55 * s);
      case 'upper_arm_right_back': return Rect.fromLTWH(218 * s, 122 * s, 24 * s, 55 * s);
      case 'elbow_left_back': return Rect.fromLTWH(50 * s, 180 * s, 28 * s, 18 * s);
      case 'elbow_right_back': return Rect.fromLTWH(222 * s, 180 * s, 28 * s, 18 * s);
      case 'forearm_left_back': return Rect.fromLTWH(52 * s, 202 * s, 22 * s, 50 * s);
      case 'forearm_right_back': return Rect.fromLTWH(226 * s, 202 * s, 22 * s, 50 * s);
      case 'hand_left_back': return Rect.fromLTWH(50 * s, 255 * s, 18 * s, 24 * s);
      case 'hand_right_back': return Rect.fromLTWH(232 * s, 255 * s, 18 * s, 24 * s);
      case 'sacrum': return Rect.fromLTWH(122 * s, 212 * s, 56 * s, 30 * s);
      case 'buttock_left': return Rect.fromLTWH(85 * s, 242 * s, 32 * s, 22 * s);
      case 'buttock_right': return Rect.fromLTWH(183 * s, 242 * s, 32 * s, 22 * s);
      case 'thigh_left_back': return Rect.fromLTWH(93 * s, 272 * s, 34 * s, 65 * s);
      case 'thigh_right_back': return Rect.fromLTWH(173 * s, 272 * s, 34 * s, 65 * s);
      case 'knee_left_back': return Rect.fromLTWH(95 * s, 340 * s, 32 * s, 18 * s);
      case 'knee_right_back': return Rect.fromLTWH(173 * s, 340 * s, 32 * s, 18 * s);
      case 'lower_leg_left_back': return Rect.fromLTWH(98 * s, 362 * s, 26 * s, 55 * s);
      case 'lower_leg_right_back': return Rect.fromLTWH(176 * s, 362 * s, 26 * s, 55 * s);
      default: return null;
    }
  }

  @override
  bool shouldRepaint(_BodyPainter oldDelegate) => true;
}
