import 'dart:math';
import 'package:flutter/material.dart';

/// A custom painter that draws an animated architectural blueprint silhouette.
///
/// Phase 1 (drawProgress 0→1): Thin architectural lines are drawn progressively,
/// simulating a drafting pen sketching a city skyline.
///
/// Phase 2 (fillOpacity 0→1): The building silhouette fills with the theme color
/// using a gradient from top to bottom.
///
/// Phase 3 (glowOpacity): A soft halo/glow appears around the shape for depth.
class BuildingBlueprintPainter extends CustomPainter {
  final double drawProgress;
  final double fillOpacity;
  final double glowOpacity;
  final Color themeColor;

  BuildingBlueprintPainter({
    required this.drawProgress,
    required this.fillOpacity,
    required this.themeColor,
    this.glowOpacity = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── 1. Faint background grid (blueprint feel) ──────────────────────────
    if (drawProgress > 0.15) {
      final gridAlpha = ((drawProgress - 0.15) / 0.85).clamp(0.0, 1.0);
      final gridPaint = Paint()
        ..color = themeColor.withValues(alpha: 0.06 * gridAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      const step = 0.1;
      for (double i = 0.0; i <= 1.0; i += step) {
        canvas.drawLine(Offset(w * i, 0), Offset(w * i, h), gridPaint);
        canvas.drawLine(Offset(0, h * i), Offset(w, h * i), gridPaint);
      }
    }

    // ── 2. Main skyline shape ──────────────────────────────────────────────
    // An architecturally-inspired skyline with a tall central tower,
    // mid-rise buildings on each side, and a small dome on the apex.
    final skyline = _buildSkylinePath(w, h);

    // Detail lines inside the building: windows, floors, facade
    final details = _buildDetailPaths(w, h);

    // ── 3. Glow shadow behind the shape (renders first) ───────────────────
    if (glowOpacity > 0 && fillOpacity > 0.3) {
      final glowPaint = Paint()
        ..color = themeColor.withValues(alpha: 0.25 * glowOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
      canvas.drawPath(skyline, glowPaint);
    }

    // ── 4. Gradient fill ───────────────────────────────────────────────────
    if (fillOpacity > 0) {
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: [
            themeColor.withValues(alpha: fillOpacity * 0.95),
            themeColor.withValues(alpha: fillOpacity * 0.55),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawPath(skyline, fillPaint);

      // Draw detail lines (windows) on top of fill
      if (fillOpacity > 0.5) {
        final detailAlpha = ((fillOpacity - 0.5) * 2).clamp(0.0, 1.0);
        final detailPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.18 * detailAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round;
        for (final p in details) {
          canvas.drawPath(p, detailPaint);
        }
      }
    }

    // ── 5. Animated blueprint stroke ───────────────────────────────────────
    if (drawProgress > 0) {
      final strokePaint = Paint()
        ..color = themeColor.withValues(alpha: (1.0 - fillOpacity * 0.6).clamp(0.3, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.miter
        ..strokeCap = StrokeCap.butt;

      final metrics = skyline.computeMetrics();
      final animated = Path();
      for (final metric in metrics) {
        animated.addPath(
          metric.extractPath(0.0, metric.length * drawProgress),
          Offset.zero,
        );
      }
      canvas.drawPath(animated, strokePaint);

      // Draw detail strokes progressively
      if (drawProgress > 0.6) {
        final detailProgress = ((drawProgress - 0.6) / 0.4).clamp(0.0, 1.0);
        final detailStroke = Paint()
          ..color = themeColor.withValues(alpha: 0.35 * detailProgress)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..strokeCap = StrokeCap.round;
        for (final p in details) {
          final dm = p.computeMetrics();
          final da = Path();
          for (final m in dm) {
            da.addPath(m.extractPath(0, m.length * detailProgress), Offset.zero);
          }
          canvas.drawPath(da, detailStroke);
        }
      }
    }

    // ── 6. Measurement tick marks (blueprint realism) ─────────────────────
    if (drawProgress > 0.4) {
      final tickAlpha = ((drawProgress - 0.4) / 0.6).clamp(0.0, 1.0);
      _drawTicks(canvas, w, h, themeColor, tickAlpha);
    }
  }

  /// Builds the main building skyline path.
  Path _buildSkylinePath(double w, double h) {
    final p = Path();

    // Ground line
    final ground = h * 0.88;

    // ── Far-left low building ──────────────────────────────
    p.moveTo(w * 0.0, ground);
    p.lineTo(w * 0.0, h * 0.72);
    p.lineTo(w * 0.08, h * 0.72);
    p.lineTo(w * 0.08, h * 0.64);
    p.lineTo(w * 0.18, h * 0.64);
    p.lineTo(w * 0.18, ground);

    // ── Left mid-rise building ─────────────────────────────
    p.moveTo(w * 0.19, ground);
    p.lineTo(w * 0.19, h * 0.44);
    // Stepped top
    p.lineTo(w * 0.22, h * 0.44);
    p.lineTo(w * 0.22, h * 0.38);
    p.lineTo(w * 0.32, h * 0.38);
    p.lineTo(w * 0.32, ground);

    // ── Central tower (tallest) ────────────────────────────
    p.moveTo(w * 0.33, ground);
    p.lineTo(w * 0.33, h * 0.28);
    // Setback
    p.lineTo(w * 0.37, h * 0.28);
    p.lineTo(w * 0.37, h * 0.16);
    // Narrow spire base
    p.lineTo(w * 0.44, h * 0.16);
    // Spire tip
    p.lineTo(w * 0.5, h * 0.04);
    p.lineTo(w * 0.56, h * 0.16);
    p.lineTo(w * 0.63, h * 0.16);
    p.lineTo(w * 0.63, h * 0.28);
    p.lineTo(w * 0.67, h * 0.28);
    p.lineTo(w * 0.67, ground);

    // ── Right mid-rise building ────────────────────────────
    p.moveTo(w * 0.68, ground);
    p.lineTo(w * 0.68, h * 0.38);
    p.lineTo(w * 0.78, h * 0.38);
    p.lineTo(w * 0.78, h * 0.44);
    p.lineTo(w * 0.81, h * 0.44);
    p.lineTo(w * 0.81, ground);

    // ── Far-right low building ─────────────────────────────
    p.moveTo(w * 0.82, ground);
    p.lineTo(w * 0.82, h * 0.64);
    p.lineTo(w * 0.92, h * 0.64);
    p.lineTo(w * 0.92, h * 0.72);
    p.lineTo(w * 1.0, h * 0.72);
    p.lineTo(w * 1.0, ground);

    // Ground base line
    p.moveTo(w * 0.0, ground);
    p.lineTo(w * 1.0, ground);

    return p;
  }

  /// Builds the window / floor detail paths drawn over the fill.
  List<Path> _buildDetailPaths(double w, double h) {
    final paths = <Path>[];

    final ground = h * 0.88;

    // Central tower window columns
    for (double col = 0.39; col <= 0.61; col += 0.07) {
      for (double row = h * 0.20; row < ground - 4; row += h * 0.09) {
        final wp = Path();
        wp.addRect(Rect.fromLTWH(w * col, row, w * 0.045, h * 0.055));
        paths.add(wp);
      }
    }

    // Left building floor lines
    for (double row = h * 0.42; row < ground - 2; row += h * 0.085) {
      final fl = Path();
      fl.moveTo(w * 0.20, row);
      fl.lineTo(w * 0.31, row);
      paths.add(fl);
    }

    // Right building floor lines
    for (double row = h * 0.42; row < ground - 2; row += h * 0.085) {
      final fl = Path();
      fl.moveTo(w * 0.69, row);
      fl.lineTo(w * 0.80, row);
      paths.add(fl);
    }

    return paths;
  }

  /// Draws small tick marks at building corners for blueprint authenticity.
  void _drawTicks(Canvas canvas, double w, double h, Color color, double alpha) {
    final tickPaint = Paint()
      ..color = color.withValues(alpha: 0.3 * alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const tickLen = 6.0;
    const positions = [
      Offset(0.0, 0.88), // bottom-left
      Offset(1.0, 0.88), // bottom-right
      Offset(0.5, 0.04), // apex
      Offset(0.37, 0.16), // tower left shoulder
      Offset(0.63, 0.16), // tower right shoulder
    ];

    for (final pos in positions) {
      final cx = w * pos.dx;
      final cy = h * pos.dy;
      canvas.drawLine(Offset(cx - tickLen, cy), Offset(cx + tickLen, cy), tickPaint);
      canvas.drawLine(Offset(cx, cy - tickLen), Offset(cx, cy + tickLen), tickPaint);
    }

    // Small arc at the spire tip (dome detail)
    if (alpha > 0.5) {
      final arcPaint = Paint()
        ..color = color.withValues(alpha: 0.25 * alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.04), width: w * 0.12, height: w * 0.12),
        pi, pi, false, arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BuildingBlueprintPainter old) {
    return old.drawProgress != drawProgress ||
        old.fillOpacity != fillOpacity ||
        old.glowOpacity != glowOpacity ||
        old.themeColor != themeColor;
  }
}
