import 'package:get/get.dart' hide TextDirection;

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;
}
