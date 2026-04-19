import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/prayer_time_utils.dart';
import '../../../../shared/models/prayer_model.dart';
import '../../../../shared/services/location_service.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../../shared/services/storage_service.dart';

class PrayerController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final LocationService _location = Get.find<LocationService>();
  final NotificationService _notifications = Get.find<NotificationService>();

  final RxList<PrayerModel> prayers = <PrayerModel>[].obs;
  final RxString currentPrayerName = ''.obs;
  final RxString nextPrayerName = ''.obs;
  final RxString nextPrayerCountdown = ''.obs;
  final RxString cityName = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString currentTime = ''.obs;

  PrayerTimes? _prayerTimes;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    cityName.value = _storage.cityName;
    _loadPrayerTimes();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateCurrentPrayer();
      currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    });
    currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
  }

  Future<void> _loadPrayerTimes() async {
    isLoading.value = true;
    try {
      // Try to get current location
      final loc = await _location.getCurrentLocation();
      if (loc != null) {
        await _storage.saveLocation(
          lat: loc['latitude'],
          lng: loc['longitude'],
          city: loc['city'],
        );
        cityName.value = loc['city'];
      }

      _prayerTimes = PrayerTimeUtils.getPrayerTimes(
        latitude: _storage.latitude,
        longitude: _storage.longitude,
        method: _storage.calculationMethod,
      );

      _updatePrayerList();
      _updateCurrentPrayer();
      if (_storage.notificationsEnabled) {
        await _scheduleNotifications();
      }
    } catch (e) {
      _loadDefaultPrayerTimes();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDefaultPrayerTimes() {
    _prayerTimes = PrayerTimeUtils.getPrayerTimes(
      latitude: _storage.latitude,
      longitude: _storage.longitude,
    );
    _updatePrayerList();
    _updateCurrentPrayer();
  }

  void _updatePrayerList() {
    if (_prayerTimes == null) return;
    final pt = _prayerTimes!;
    final current = PrayerTimeUtils.prayerToString(
        PrayerTimeUtils.getCurrentPrayer(pt));

    prayers.value = PrayerModel.fromPrayerTimes(
      fajr: PrayerTimeUtils.formatTime(pt.fajr),
      sunrise: PrayerTimeUtils.formatTime(pt.sunrise),
      dhuhr: PrayerTimeUtils.formatTime(pt.dhuhr),
      asr: PrayerTimeUtils.formatTime(pt.asr),
      maghrib: PrayerTimeUtils.formatTime(pt.maghrib),
      isha: PrayerTimeUtils.formatTime(pt.isha),
      activePrayer: current,
    );
  }

  void _updateCurrentPrayer() {
    if (_prayerTimes == null) return;
    final current = PrayerTimeUtils.getCurrentPrayer(_prayerTimes!);
    final next = _prayerTimes!.nextPrayer();
    currentPrayerName.value = PrayerTimeUtils.prayerToString(current);
    nextPrayerName.value = PrayerTimeUtils.prayerToString(next);
    nextPrayerCountdown.value =
        PrayerTimeUtils.getNextPrayerCountdown(_prayerTimes!);
    _updatePrayerList();
  }

  Future<void> _scheduleNotifications() async {
    if (_prayerTimes == null) return;
    await _notifications.cancelAllPrayerNotifications();
    final pt = _prayerTimes!;
    final prayersList = [
      {'name': 'Fajr', 'time': pt.fajr},
      {'name': 'Dhuhr', 'time': pt.dhuhr},
      {'name': 'Asr', 'time': pt.asr},
      {'name': 'Maghrib', 'time': pt.maghrib},
      {'name': 'Isha', 'time': pt.isha},
    ];

    for (int i = 0; i < prayersList.length; i++) {
      final p = prayersList[i];
      final time = p['time'] as DateTime?;
      if (time != null && time.isAfter(DateTime.now())) {
        await _notifications.schedulePrayerNotification(
          id: i + 100,
          prayerName: p['name'] as String,
          prayerTime: PrayerTimeUtils.formatTime(time),
          scheduledTime: time,
        );
      }
    }
  }

  Future<void> refreshLocation() async {
    await _loadPrayerTimes();
  }

  String get fajrTime => _prayerTimes != null
      ? PrayerTimeUtils.formatTime(_prayerTimes!.fajr)
      : '--:--';
}
