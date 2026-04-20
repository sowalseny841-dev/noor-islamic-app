import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../shared/models/azkar_model.dart';
import '../../../../shared/services/storage_service.dart';

class AzkarController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<AzkarCategory> categories = <AzkarCategory>[].obs;
  final RxList<AzkarItem> currentAzkar = <AzkarItem>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = true.obs;
  final RxInt currentIndex = 0.obs;

  List<AzkarItem> _allAzkar = [];

  @override
  void onInit() {
    super.onInit();
    _loadAzkar();
  }

  Future<void> _loadAzkar() async {
    isLoading.value = true;
    try {
      final String data =
          await rootBundle.loadString('assets/json/azkar.json');
      final json = jsonDecode(data);

      final progress = _storage.azkarProgress;

      _allAzkar = (json['azkar'] as List)
          .map((item) => AzkarItem(
                id: item['id'],
                categoryId: item['categoryId'],
                arabic: item['arabic'],
                transliteration: item['transliteration'],
                translation: item['translation'],
                source: item['source'],
                repeatCount: item['repeatCount'],
                benefit: item['benefit'],
                currentCount: progress['${item['id']}'] ?? 0,
                isDone: (progress['${item['id']}'] ?? 0) >= item['repeatCount'],
              ))
          .toList();

      final cats = (json['categories'] as List).map((c) {
        final catAzkar = _allAzkar.where((a) => a.categoryId == c['id']);
        final readCount = catAzkar.where((a) => a.isDone).length;
        return AzkarCategory(
          id: c['id'],
          name: c['name'],
          nameAr: c['nameAr'],
          icon: c['icon'],
          totalCount: c['totalCount'],
          readCount: readCount,
        );
      }).toList();

      categories.value = cats;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les azkar');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String categoryId) {
    selectedCategory.value = categoryId;
    currentIndex.value = 0;
    currentAzkar.value =
        _allAzkar.where((a) => a.categoryId == categoryId).toList();
  }

  Future<void> incrementCurrentZikr() async {
    if (currentAzkar.isEmpty) return;
    final idx = currentIndex.value;
    final updated = currentAzkar[idx].increment();
    currentAzkar[idx] = updated;

    await _storage.setAzkarProgress('${updated.id}', updated.currentCount);

    if (updated.isCompleted && idx < currentAzkar.length - 1) {
      await Future.delayed(const Duration(milliseconds: 500));
      currentIndex.value = idx + 1;
    }
    _updateCategoryProgress(updated.categoryId);
  }

  void _updateCategoryProgress(String catId) {
    final catAzkar = _allAzkar.where((a) => a.categoryId == catId);
    final readCount = catAzkar.where((a) => a.isDone).length;
    final idx = categories.indexWhere((c) => c.id == catId);
    if (idx != -1) {
      categories[idx] = categories[idx].copyWith(readCount: readCount);
    }
  }

  void resetCategory(String categoryId) {
    for (int i = 0; i < _allAzkar.length; i++) {
      if (_allAzkar[i].categoryId == categoryId) {
        _allAzkar[i] = AzkarItem(
          id: _allAzkar[i].id,
          categoryId: _allAzkar[i].categoryId,
          arabic: _allAzkar[i].arabic,
          transliteration: _allAzkar[i].transliteration,
          translation: _allAzkar[i].translation,
          source: _allAzkar[i].source,
          repeatCount: _allAzkar[i].repeatCount,
          benefit: _allAzkar[i].benefit,
        );
        _storage.setAzkarProgress('${_allAzkar[i].id}', 0);
      }
    }
    currentAzkar.value =
        _allAzkar.where((a) => a.categoryId == categoryId).toList();
    currentIndex.value = 0;
    _updateCategoryProgress(categoryId);
  }

  AzkarCategory? getCategoryById(String id) =>
      categories.firstWhereOrNull((c) => c.id == id);
}
