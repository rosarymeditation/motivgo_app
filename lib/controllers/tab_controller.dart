import 'package:get/get.dart';

class MainTabController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void setTab(int index) {
    selectedIndex.value = index;
  }
}
