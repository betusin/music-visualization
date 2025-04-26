enum VibrationStatus {
  playing('playing'),
  finished('finished'),
  paused('paused');

  final String value;

  const VibrationStatus(this.value);
}
