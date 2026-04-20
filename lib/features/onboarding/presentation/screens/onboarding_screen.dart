import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide TextDirection;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../shared/services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Rappels de Prière',
      titleAr: 'أوقات الصلاة',
      description:
          'Recevez les horaires de prière précis basés sur votre localisation avec des rappels Azan personnalisables.',
      icon: '🕌',
      gradientColors: [const Color(0xFF003A1F), const Color(0xFF006B3C)],
    ),
    _OnboardingData(
      title: 'Le Saint Coran',
      titleAr: 'القرآن الكريم',
      description:
          'Lisez et écoutez le Coran complet avec traduction française et récitations de célèbres récitateurs.',
      icon: '📖',
      gradientColors: [const Color(0xFF1A0A00), const Color(0xFF4A2000)],
    ),
    _OnboardingData(
      title: 'Azkar & Tasbih',
      titleAr: 'الأذكار والتسبيح',
      description:
          'Suivez vos azkar quotidiens du matin et du soir, et utilisez le tasbih électronique.',
      icon: '📿',
      gradientColors: [const Color(0xFF001A3A), const Color(0xFF003A7A)],
    ),
    _OnboardingData(
      title: 'Communauté Ummah',
      titleAr: 'أمة واحدة',
      description:
          'Partagez des récitations, des moments spirituels et connectez-vous avec la communauté musulmane.',
      icon: '🌙',
      gradientColors: [const Color(0xFF1A0030), const Color(0xFF400070)],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() async {
    final storage = Get.find<StorageService>();
    await storage.setOnboardingDone();
    Get.offAllNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final isLast = _currentPage == _pages.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
        ),
      ),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.gold,
              dotColor: AppColors.white.withOpacity(0.4),
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (!isLast)
                TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Passer',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  ),
                )
              else
                const SizedBox(width: 80),
              const Spacer(),
              GestureDetector(
                onTap: _nextPage,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String titleAr;
  final String description;
  final String icon;
  final List<Color> gradientColors;

  const _OnboardingData({
    required this.title,
    required this.titleAr,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: data.gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Mosque silhouette
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _MosquePainter(),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 60, 32, 140),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Text(
                    data.icon,
                    style: const TextStyle(fontSize: 80),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.elasticOut)
                      .fadeIn(),
                  const SizedBox(height: 40),
                  // Arabic title
                  Text(
                    data.titleAr,
                    style: AppTextStyles.arabicLarge(
                      color: AppColors.goldLight,
                    ).copyWith(fontSize: 32),
                    textDirection: TextDirection.rtl,
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 12),
                  // French title
                  Text(
                    data.title,
                    style: AppTextStyles.heading1(color: AppColors.white)
                        .copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 24),
                  Container(
                    height: 2,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ).animate(delay: 400.ms).scaleX(duration: 400.ms),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    data.description,
                    style: AppTextStyles.bodyLarge(
                      color: AppColors.white.withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, h);
    path.lineTo(0, h * 0.6);
    path.lineTo(w * 0.08, h * 0.6);
    path.lineTo(w * 0.08, h * 0.15);
    path.quadraticBezierTo(w * 0.1, 0, w * 0.12, h * 0.15);
    path.lineTo(w * 0.12, h * 0.6);
    path.lineTo(w * 0.3, h * 0.6);
    path.lineTo(w * 0.3, h * 0.4);
    path.quadraticBezierTo(w * 0.35, h * 0.2, w * 0.4, h * 0.4);
    path.lineTo(w * 0.4, h * 0.6);
    path.lineTo(w * 0.42, h * 0.6);
    path.lineTo(w * 0.42, h * 0.45);
    path.quadraticBezierTo(w * 0.5, h * 0.0, w * 0.58, h * 0.45);
    path.lineTo(w * 0.58, h * 0.6);
    path.lineTo(w * 0.6, h * 0.6);
    path.lineTo(w * 0.6, h * 0.4);
    path.quadraticBezierTo(w * 0.65, h * 0.2, w * 0.7, h * 0.4);
    path.lineTo(w * 0.7, h * 0.6);
    path.lineTo(w * 0.88, h * 0.6);
    path.lineTo(w * 0.88, h * 0.15);
    path.quadraticBezierTo(w * 0.9, 0, w * 0.92, h * 0.15);
    path.lineTo(w * 0.92, h * 0.6);
    path.lineTo(w, h * 0.6);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
