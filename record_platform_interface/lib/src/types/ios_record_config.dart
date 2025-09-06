/// iOS specific configuration for recording.
class IosRecordConfig {
  /// Constants that specify optional audio behaviors.
  ///
  /// https://developer.apple.com/documentation/avfaudio/avaudiosession/categoryoptions
  final List<IosAudioCategoryOption> categoryOptions;

  /// Manage the shared AVAudioSession (defaults to `true`).
  ///
  /// Set this to `false` if another plugin is already managing the AVAudioSession.
  ///
  /// If `false`, there will be no check of the [RecordConfig] given.
  final bool manageAudioSession;

  /// Enable background recording using background audio mode.
  /// When enabled, the recording will continue even when the app is minimized.
  /// 
  /// This requires the 'audio' background mode to be declared in Info.plist.
  /// Defaults to [false].
  final bool enableBackgroundRecording;

  const IosRecordConfig({
    this.categoryOptions = const [
      IosAudioCategoryOption.defaultToSpeaker,
      IosAudioCategoryOption.allowBluetooth,
      IosAudioCategoryOption.allowBluetoothA2DP,
    ],
    this.manageAudioSession = true,
    this.enableBackgroundRecording = false,
  });
  Map<String, dynamic> toMap() {
    return {
      "categoryOptions": categoryOptions.map((e) => e.name).join(','),
      "manageAudioSession": manageAudioSession,
      "enableBackgroundRecording": enableBackgroundRecording,
    };
  }
}

/// Constants that specify optional audio behaviors.
///
/// https://developer.apple.com/documentation/avfaudio/avaudiosession/categoryoptions
enum IosAudioCategoryOption {
  mixWithOthers,
  duckOthers,
  allowBluetooth,
  defaultToSpeaker,

  /// available from iOS 9.0
  interruptSpokenAudioAndMixWithOthers,

  /// available from iOS 10.0
  allowBluetoothA2DP,

  /// available from iOS 10.0
  allowAirPlay,

  /// available from iOS 14.5
  overrideMutedMicrophoneInterruption
}
