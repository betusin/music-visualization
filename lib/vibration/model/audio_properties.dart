class AudioProperties {
  final int sampleRate;
  final int channels;
  final String? channelLayout;

  const AudioProperties({required this.sampleRate, required this.channels, required this.channelLayout});
}
