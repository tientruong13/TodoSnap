import 'package:vibration/vibration.dart';

Future<void> vibrateFor1Second() async {
  bool? canVibrate = await Vibration.hasVibrator();
  if (canVibrate != null && canVibrate) {
    Vibration.vibrate(duration: 10); // 1000 ms = 1 s
  }
} //Create and edit

Future<void> vibrateForAhalfSeconds() async {
  bool? canVibrate = await Vibration.hasVibrator();
  if (canVibrate != null && canVibrate) {
    Vibration.vibrate(duration: 5); // 2000 ms = 2 s
  }
} //tapp button

Future<void> vibrateFor3time() async {
  bool? canVibrate = await Vibration.hasVibrator();
  if (canVibrate != null && canVibrate) {
    Vibration.vibrate(pattern: [10, 10, 10, 10]); // 3000 ms = 3 s
  }
}
