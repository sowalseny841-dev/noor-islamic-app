import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final bool showMosqueIllustration;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.showMosqueIllustration = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ??
              [
                AppColors.primaryGradientStart,
                AppColors.primary,
                AppColors.primaryGradientEnd,
              ],
        ),
      ),
      child: Stack(
        children: [
          if (showMosqueIllustration) _buildMosqueOverlay(),
          child,
        ],
      ),
    );
  }

  Widget _buildMosqueOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: 0.15,
        child: CustomPaint(
          size: const Size(double.infinity, 200),
          painter: MosqueSilhouettePainter(),
        ),
      ),
    );
  }
}

class MosqueSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Ground
    path.moveTo(0, h);
    path.lineTo(0, h * 0.6);

    // Left minaret
    path.lineTo(w * 0.05, h * 0.6);
    path.lineTo(w * 0.05, h * 0.2);
    path.quadraticBezierTo(w * 0.075, h * 0.05, w * 0.1, h * 0.2);
    path.lineTo(w * 0.1, h * 0.6);

    // Left section
    path.lineTo(w * 0.25, h * 0.6);
    path.lineTo(w * 0.25, h * 0.4);
    path.quadraticBezierTo(w * 0.3, h * 0.3, w * 0.35, h * 0.4);
    path.lineTo(w * 0.35, h * 0.6);

    // Main dome
    path.lineTo(w * 0.38, h * 0.6);
    path.lineTo(w * 0.38, h * 0.45);
    path.quadraticBezierTo(w * 0.5, h * 0.0, w * 0.62, h * 0.45);
    path.lineTo(w * 0.62, h * 0.6);

    // Right section
    path.lineTo(w * 0.65, h * 0.6);
    path.lineTo(w * 0.65, h * 0.4);
    path.quadraticBezierTo(w * 0.7, h * 0.3, w * 0.75, h * 0.4);
    path.lineTo(w * 0.75, h * 0.6);

    // Right minaret
    path.lineTo(w * 0.9, h * 0.6);
    path.lineTo(w * 0.9, h * 0.2);
    path.quadraticBezierTo(w * 0.925, h * 0.05, w * 0.95, h * 0.2);
    path.lineTo(w * 0.95, h * 0.6);

    path.lineTo(w, h * 0.6);
    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
