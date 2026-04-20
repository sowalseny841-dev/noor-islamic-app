import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class UmmahScreen extends StatefulWidget {
  const UmmahScreen({super.key});

  @override
  State<UmmahScreen> createState() => _UmmahScreenState();
}

class _UmmahScreenState extends State<UmmahScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _filterIndex = 0;
  final List<String> _filters = ['Tout', 'Partage de vie', 'Dua', 'Coran'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryLight,
          labelStyle: AppTextStyles.bodyMedium(color: AppColors.primary)
              .copyWith(fontWeight: FontWeight.w600),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Recommandé'),
            Tab(text: 'Abonnements'),
            Tab(text: 'À pr...'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RecommendedFeed(
            filterIndex: _filterIndex,
            filters: _filters,
            onFilterChanged: (i) => setState(() => _filterIndex = i),
          ),
          _EmptyFeed(message: 'Abonnez-vous à des utilisateurs pour voir leur contenu'),
          _EmptyFeed(message: 'Contenu à proximité'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePost(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _showCreatePost(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Créer un post', style: AppTextStyles.heading3()),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🌿', style: TextStyle(fontSize: 24))),
                ),
                title: const Text('Partager votre vie quotidienne\nou vos explorations'),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('📖', style: TextStyle(fontSize: 24))),
                ),
                title: const Text('Partager une récitation du Coran'),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🤲', style: TextStyle(fontSize: 24))),
                ),
                title: const Text('Partager un Dua'),
                onTap: () => Get.back(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedFeed extends StatelessWidget {
  final int filterIndex;
  final List<String> filters;
  final ValueChanged<int> onFilterChanged;

  const _RecommendedFeed({
    required this.filterIndex,
    required this.filters,
    required this.onFilterChanged,
  });

  static final List<_PostData> _posts = [
    _PostData(
      author: 'Salah',
      avatarEmoji: '👤',
      likes: 77700,
      text: 'Louange à Allah qui nous a guidés à ceci. Nous n\'aurions pas...',
      image: null,
      type: 'Partage de vie',
    ),
    _PostData(
      author: 'Rashid',
      avatarEmoji: '👤',
      likes: 36200,
      text: 'Nous sommes très heureux que vous ayez décidé d\'embr...',
      image: null,
      type: 'Coran',
    ),
    _PostData(
      author: 'Amina',
      avatarEmoji: '👩',
      likes: 12400,
      text: 'SubhanAllah, la mosquée al-Aqsa dans toute sa splendeur...',
      image: null,
      type: 'Partage de vie',
    ),
    _PostData(
      author: 'Ibrahim',
      avatarEmoji: '👤',
      likes: 8900,
      text: 'اللَّهُمَّ اجْعَلْنَا مِنَ الْمُقَرَّبِينَ...\nDua pour nous rapprocher d\'Allah.',
      image: null,
      type: 'Dua',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Create post banner
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('🌿', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Partagez votre vie quotidienne\nou vos explorations',
                            style: AppTextStyles.bodyMedium(
                                color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Filter chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () => onFilterChanged(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: filterIndex == i
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: filterIndex == i
                                ? AppColors.primary
                                : AppColors.dividerLight,
                          ),
                        ),
                        child: Text(
                          filters[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: filterIndex == i
                                ? Colors.white
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Posts grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _PostCard(post: _posts[i % _posts.length])
                  .animate(delay: (i * 80).ms)
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.95, 0.95)),
              childCount: _posts.length * 2,
            ),
          ),
        ),
      ],
    );
  }
}

class _PostData {
  final String author;
  final String avatarEmoji;
  final int likes;
  final String text;
  final String? image;
  final String type;

  const _PostData({
    required this.author,
    required this.avatarEmoji,
    required this.likes,
    required this.text,
    this.image,
    required this.type,
  });
}

class _PostCard extends StatelessWidget {
  final _PostData post;

  const _PostCard({required this.post});

  String _formatLikes(int likes) {
    if (likes >= 1000) {
      return '${(likes / 1000).toStringAsFixed(1)}K';
    }
    return '$likes';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = [
      AppColors.primaryDark,
      AppColors.primary,
      const Color(0xFF1A472A),
      const Color(0xFF2D6A4F),
    ];
    final color = colors[post.author.hashCode % colors.length];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.3,
                      child: CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: _MiniMosquePainter(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      post.text,
                      style: AppTextStyles.bodySmall(color: AppColors.white),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(post.avatarEmoji,
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(post.author, style: AppTextStyles.bodySmall()),
                ),
                const Icon(Icons.thumb_up_outlined,
                    size: 14, color: AppColors.textSecondaryLight),
                const SizedBox(width: 2),
                Text(_formatLikes(post.likes),
                    style: AppTextStyles.bodySmall()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  final String message;
  const _EmptyFeed({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(message,
                style: AppTextStyles.bodyLarge(),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

class _MiniMosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, h);
    path.lineTo(0, h * 0.7);
    path.lineTo(w * 0.15, h * 0.7);
    path.lineTo(w * 0.15, h * 0.4);
    path.quadraticBezierTo(w * 0.2, h * 0.2, w * 0.25, h * 0.4);
    path.lineTo(w * 0.25, h * 0.7);
    path.lineTo(w * 0.38, h * 0.7);
    path.lineTo(w * 0.38, h * 0.55);
    path.quadraticBezierTo(w * 0.5, h * 0.25, w * 0.62, h * 0.55);
    path.lineTo(w * 0.62, h * 0.7);
    path.lineTo(w * 0.75, h * 0.7);
    path.lineTo(w * 0.75, h * 0.4);
    path.quadraticBezierTo(w * 0.8, h * 0.2, w * 0.85, h * 0.4);
    path.lineTo(w * 0.85, h * 0.7);
    path.lineTo(w, h * 0.7);
    path.lineTo(w, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
