class AzkarCategory {
  final String id;
  final String name;
  final String nameAr;
  final String icon;
  final int totalCount;
  final int readCount;

  const AzkarCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.totalCount,
    this.readCount = 0,
  });

  AzkarCategory copyWith({int? readCount}) => AzkarCategory(
        id: id,
        name: name,
        nameAr: nameAr,
        icon: icon,
        totalCount: totalCount,
        readCount: readCount ?? this.readCount,
      );
}

class AzkarItem {
  final int id;
  final String categoryId;
  final String arabic;
  final String transliteration;
  final String translation;
  final String source;
  final int repeatCount;
  final String? benefit;
  bool isDone;
  int currentCount;

  AzkarItem({
    required this.id,
    required this.categoryId,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.repeatCount,
    this.benefit,
    this.isDone = false,
    this.currentCount = 0,
  });

  bool get isCompleted => currentCount >= repeatCount;

  AzkarItem increment() {
    final newCount = (currentCount + 1).clamp(0, repeatCount);
    return AzkarItem(
      id: id,
      categoryId: categoryId,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      source: source,
      repeatCount: repeatCount,
      benefit: benefit,
      isDone: newCount >= repeatCount,
      currentCount: newCount,
    );
  }
}
