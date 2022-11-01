import 'components/timer.dart';

class SharedData {
  static final Map<int, CookTimer> _cookTimers = {};

  static getCookTimers() {
    return _cookTimers;
  }
}
