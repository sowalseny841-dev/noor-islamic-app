import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'shared/services/storage_service.dart';
import 'shared/services/location_service.dart';
import 'shared/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Initialize services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => LocationService().init()).catchError((_) => LocationService());
  await Get.putAsync(() => NotificationService().init()).catchError((_) => NotificationService());

  runApp(const NoorApp());
}
