import 'components/timer.dart';

class SharedData {
  static final Map<int, CookTimer> _cookTimers = {};
  static final Map<int, Duration> _leftDurs = {};

  static getCookTimers() {
    return _cookTimers;
  }

  static getLeftDurs() {
    return _leftDurs;
  }
}
