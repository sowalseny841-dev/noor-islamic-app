import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide TextDirection;
import '../../../../shared/services/storage_service.dart';

class TasbihItem {
  final int id;
  final String arabic;
  final String transliteration;
  final String translation;
  final int targetCount;
  final String benefit;

  const TasbihItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.targetCount,
    required this.benefit,
  });
}

class TasbihController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxInt count = 0.obs;
  final RxInt rounds = 1.obs;
  final RxInt selectedIndex = 0.obs;
  final RxList<TasbihItem> tasbihList = <TasbihItem>[].obs;
  final RxBool vibrateEnabled = true.obs;
  final RxBool soundEnabled = false.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTasbih();
  }

  Future<void> _loadTasbih() async {
    isLoading.value = true;
    try {
      final data = await rootBundle.loadString('assets/json/tasbih.json');
      final json = jsonDecode(data);
      tasbihList.value = (json['tasbih_list'] as List)
          .map((item) => TasbihItem(
                id: item['id'],
                arabic: item['arabic'],
                transliteration: item['transliteration'],
                translation: item['translation'],
                targetCount: item['count'],
                benefit: item['benefit'],
              ))
          .toList();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les tasbih');
    } finally {
      isLoading.value = false;
    }
  }

  TasbihItem? get currentTasbih =>
      tasbihList.isNotEmpty ? tasbihList[selectedIndex.value] : null;

  int get targetCount => currentTasbih?.targetCount ?? 33;

  void increment() {
    HapticFeedback.lightImpact();
    if (count.value < targetCount) {
      count.value++;
    } else {
      count.value = 0;
      rounds.value++;
      HapticFeedback.mediumImpact();
    }
  }

  void reset() {
    count.value = 0;
    rounds.value = 1;
  }

  void selectTasbih(int index) {
    selectedIndex.value = index;
    reset();
  }

  double get progress =>
      targetCount > 0 ? count.value / targetCount : 0.0;
}
