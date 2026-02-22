import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends Notifier<int> {
  @override
  int build() {
    return 0; // Default to Dashboard tab
  }

  void setTab(int index) {
    state = index;
  }

  void goToDashboard() {
    state = 0;
  }

  void goToAddRecord() {
    state = 1;
  }

  void goToStatistics() {
    state = 2;
  }
}

final navigationProvider = NotifierProvider<NavigationNotifier, int>(() {
  return NavigationNotifier();
});
