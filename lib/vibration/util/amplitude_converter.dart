import 'package:vibration_poc/vibration/util/amplitude_constants.dart';

class AmplitudeConverter {
  static num mapDbFsToVibrationAmplitude(num value) {
    return mapValue(value, minDbFS, maxDbFS, minAmplitude, maxAmplitude);
  }

  /// Constrains a number between a minimum and maximum value.
  static num constrain(num value, num low, num high) {
    // TODO(betka): validate params
    return value.clamp(low, high);
  }

  /// Maps a given `value` from one range (`start1` to `stop1`) to another (`start2` to `stop2`).
  ///
  /// This function performs a linear transformation of `value` so that a number in the
  /// input range is proportionally scaled to the output range.
  static num mapValue(num value, num start1, num stop1, num start2, num stop2, [bool withinBounds = false]) {
    // TODO(betka): validate params
    // return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2;
    final mappedValue = start2 + (value - start1) / (stop1 - start1) * (stop2 - start2);
    if (!withinBounds) {
      return mappedValue;
    }
    if (start2 < stop2) {
      return constrain(mappedValue, start2, stop2);
    }
    return constrain(mappedValue, stop2, start2);
  }
}
