class VibrationConfig {
  /// beat in milliseconds, define delay between amplitude
  final int beat;

  /// amplitudes of vibration in dbFs
  final List<double> amplitudes;

  const VibrationConfig(this.beat, this.amplitudes);
}
