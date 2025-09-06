/// Android specific configuration for recording.
class AndroidRecordConfig {
  /// Uses Android MediaRecorder if [true].
  ///
  /// Uses advanced recorder with media codecs and additionnal features
  /// by default.
  ///
  /// While advanced recorder unlocks additionnal features, legacy recorder
  /// is stability oriented.
  final bool useLegacy;

  /// If [true], this will mute all audio streams like alarms, music, ring, ...
  ///
  /// This is useful when you want to record audio without any background noise.
  ///
  /// The streams are restored to their previous state after recording is stopped
  /// and will stay at current state on pause/resume.
  ///
  /// Use at your own risks!
  final bool muteAudio;

  /// Try to start a bluetooth audio connection to a headset (Bluetooth SCO).
  ///
  /// Defaults to [true].
  final bool manageBluetooth;

  /// Defines the audio source.
  /// An audio source defines both a default physical source of audio signal, and a recording configuration.
  ///
  /// Depending of the constructor some effects are available or not depending of this source.
  ///
  /// Most of the time, you should use [AndroidAudioSource.defaultSource] or [AndroidAudioSource.mic].
  final AndroidAudioSource audioSource;

  /// Set the speakerphone on.
  /// If [true], this will set the speakerphone on and might help to resolve
  /// acoustic echo cancellation issues on some devices.
  ///
  /// Defaults to [false].
  final bool speakerphone;

  /// Defines the audio manager mode.
  /// This is used to set the audio manager mode before recording.
  ///
  /// Switching to [AudioManagerMode.modeInCommunication] might help to resolve
  /// acoustic echo cancellation issues on some devices.
  ///
  /// Defaults to [AudioManagerMode.modeNormal].
  final AudioManagerMode audioManagerMode;

  /// Enable background recording using a foreground service.
  /// When enabled, the recording will continue even when the app is minimized or killed.
  /// 
  /// This requires proper permissions and notification setup.
  /// Defaults to [false].
  final bool enableBackgroundRecording;

  /// Title for the foreground service notification.
  /// Only used when [enableBackgroundRecording] is true.
  /// 
  /// Defaults to "Recording audio".
  final String notificationTitle;

  /// Content text for the foreground service notification.
  /// Only used when [enableBackgroundRecording] is true.
  /// 
  /// Defaults to "Audio recording is active".
  final String notificationText;

  /// Icon resource name for the foreground service notification.
  /// Should be a drawable resource in your Android app.
  /// Only used when [enableBackgroundRecording] is true.
  /// 
  /// If null, uses the default app icon.
  final String? notificationIcon;

  const AndroidRecordConfig({
    this.useLegacy = false,
    this.muteAudio = false,
    this.manageBluetooth = true,
    this.audioSource = AndroidAudioSource.defaultSource,
    this.speakerphone = false,
    this.audioManagerMode = AudioManagerMode.modeNormal,
    this.enableBackgroundRecording = false,
    this.notificationTitle = "Recording audio",
    this.notificationText = "Audio recording is active",
    this.notificationIcon,
  });

  /// Transforms model to JSON map.
  Map<String, dynamic> toMap() {
    return {
      'useLegacy': useLegacy,
      'muteAudio': muteAudio,
      'manageBluetooth': manageBluetooth,
      'audioSource': audioSource.name,
      'speakerphone': speakerphone,
      'audioManagerMode': audioManagerMode.name,
      'enableBackgroundRecording': enableBackgroundRecording,
      'notificationTitle': notificationTitle,
      'notificationText': notificationText,
      'notificationIcon': notificationIcon,
    };
  }
}

/// Constants for Android for setting specific audio source types
///
/// https://developer.android.com/reference/kotlin/android/media/MediaRecorder.AudioSource
enum AndroidAudioSource {
  defaultSource,
  mic,
  voiceUplink,
  voiceDownlink,
  voiceCall,
  camcorder,
  voiceRecognition,
  voiceCommunication,
  remoteSubMix,

  /// Build.VERSION_CODES.N
  unprocessed,

  /// Build.VERSION_CODES.Q
  voicePerformance,
}

/// Constants for Android for setting specific audio manager modes
///
/// https://developer.android.com/reference/kotlin/android/media/AudioManager#setmode
enum AudioManagerMode {
  modeNormal,
  modeRingtone,
  modeInCall,
  modeInCommunication,

  /// Build.VERSION_CODES.R
  modeCallScreening,

  /// Build.VERSION_CODES.TIRAMISU
  modeCallRedirect,

  /// Build.VERSION_CODES.TIRAMISU
  modeCommunicationRedirect,
}
