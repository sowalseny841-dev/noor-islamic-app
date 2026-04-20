import 'dart:ui' show TextDirection;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/services/storage_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double _qiblaAngle = 0;

  @override
  void initState() {
    super.initState();
    _calculateQiblaAngle();
  }

  void _calculateQiblaAngle() {
    final storage = Get.find<StorageService>();
    const kaabaLat = 21.4225 * math.pi / 180;
    const kaabaLng = 39.8262 * math.pi / 180;
    final userLat = storage.latitude * math.pi / 180;
    final userLng = storage.longitude * math.pi / 180;

    final dLng = kaabaLng - userLng;
    final y = math.sin(dLng) * math.cos(kaabaLat);
    final x = math.cos(userLat) * math.sin(kaabaLat) -
        math.sin(userLat) * math.cos(kaabaLat) * math.cos(dLng);
    final bearing = math.atan2(y, x) * 180 / math.pi;
    setState(() => _qiblaAngle = (bearing + 360) % 360);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text('Qibla',
                            style: AppTextStyles.heading3(color: AppColors.white)),
                        Text('القبلة',
                            style: AppTextStyles.arabicSmall(
                                color: AppColors.goldLight)),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Spacer(),
              // Compass
              StreamBuilder<CompassEvent>(
                stream: FlutterCompass.events,
                builder: (ctx, snap) {
                  double compassAngle = 0;
                  if (snap.hasData && snap.data?.heading != null) {
                    compassAngle = snap.data!.heading!;
                  }
                  final qiblaRotation =
                      (_qiblaAngle - compassAngle) * math.pi / 180;

                  return Column(
                    children: [
                      Transform.rotate(
                        angle: qiblaRotation,
                        child: _CompassWidget(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${_qiblaAngle.toStringAsFixed(1)}°',
                        style: AppTextStyles.heading2(color: AppColors.white),
                      ),
                      Text(
                        'Direction de la Qibla',
                        style: AppTextStyles.bodyMedium(
                            color: AppColors.white.withOpacity(0.8)),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.gold.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.gold, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Éloignez-vous des objets métalliques pour une lecture précise.',
                          style: AppTextStyles.bodySmall(
                              color: AppColors.white.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompassWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: _CompassPainter(),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Text('🕋', style: TextStyle(fontSize: 28)),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 2, circlePaint);

    // Inner dashes
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 36; i++) {
      final angle = i * math.pi / 18;
      final isMajor = i % 9 == 0;
      final inner = radius - (isMajor ? 20 : 10);
      final outer = radius - 4;
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(angle),
            center.dy + inner * math.sin(angle)),
        Offset(center.dx + outer * math.cos(angle),
            center.dy + outer * math.sin(angle)),
        dashPaint,
      );
    }

    // North arrow
    final arrowPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(center.dx, center.dy - radius + 30);
    path.lineTo(center.dx - 8, center.dy - radius + 55);
    path.lineTo(center.dx, center.dy - radius + 45);
    path.lineTo(center.dx + 8, center.dy - radius + 55);
    path.close();
    canvas.drawPath(path, arrowPaint);

    // Direction labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final dirs = ['N', 'E', 'S', 'O'];
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2;
      final pos = Offset(
        center.dx + (radius - 35) * math.cos(angle) - 8,
        center.dy + (radius - 35) * math.sin(angle) - 10,
      );
      textPainter.text = TextSpan(
        text: dirs[i],
        style: TextStyle(
          color: i == 0 ? AppColors.gold : Colors.white.withOpacity(0.7),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, pos);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
