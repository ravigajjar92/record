Audio recorder from microphone to a given file path or stream.  

No external dependencies:

- On Android, AudioRecord and MediaCodec or MediaRecorder.
- On iOS and macOS, AVFoundation.
- On Windows, MediaFoundation.
- On web, well... your browser! (and its underlying platform).

External dependencies:
- On linux, encoding is provided by `parecord` and `ffmpeg`. It **must** be installed separately.

## Platform feature parity matrix
| Feature          | Android       | iOS             | web     | Windows    | macOS  | linux
|------------------|---------------|-----------------|---------|------------|-------|-----------
| pause/resume     | ✔️            |   ✔️             | ✔️     |      ✔️    | ✔️    |  ✔️
| amplitude(dBFS)  | ✔️            |   ✔️             |  ✔️     |    ✔️     |  ✔️   |
| permission check | ✔️            |   ✔️             |  ✔️    |            |  ✔️   |
| num of channels  | ✔️            |   ✔️             |  ✔️    |    ✔️      |  ✔️   |  ✔️
| device selection | ✔️ 1 / 2      | (auto BT/mic)    |  ✔️    |    ✔️      |  ✔️   |  ✔️
| auto gain        | ✔️ 2          | ✔️ 3             | ✔️      |            |  ✔️ 3     | 
| echo cancel      | ✔️ 2          | ✔️ 3             | ✔️      |            |  ✔️ 3     | 
| noise suppresion | ✔️ 2          |                  | ✔️      |            |       | 

## File
| Encoder         | Android        | iOS     | web     | Windows | macOS   | linux
|-----------------|----------------|---------|---------|---------|---------|---------
| aacLc           | ✔️            |   ✔️    |  ?      |   ✔️    |  ✔️    |  ✔️ 
| aacEld          | ✔️            |   ✔️    |   ?     |         |  ✔️    | 
| aacHe           | ✔️            |         |   ?     |         |         |   
| amrNb           | ✔️            |         |  ?      |   ✔️    |         |  
| amrWb           | ✔️            |         |  ?      |          |        |  
| opus            | ✔️            |   ✔️ 4    |  ?       |         |         |  ✔️ 
| wav             | ✔️ 2          |   ✔️    |   ✔️   |    ✔️    |   ✔️  |   ✔️ 
| flac            | ✔️ 2          |    ✔️    |  ?     |  ✔️     |   ✔️   |   ✔️
| pcm16bits       | ✔️ 2          |   ✔️    |  ✔️    |   ✔️    |  ✔️    |  

?: from my testings:
| Encoder         | Firefox    | Chrome based   | Safari
|-----------------|------------|----------------|---------
| aacLc           |            |                |  ✔️*
| opus            | ✔️*        |   ✔️*           | 
| wav             | ✔️        |   ✔️           |   ✔️
| pcm16bits       | ✔️        |   ✔️           |  ✔️

\* Sample rate output is determined by your settings in OS. Bit depth is likely 32 bits.

wav and pcm16bits are provided by the package directly.

## Stream
| Encoder         | Android    | iOS     | web     | Windows | macOS   | linux
|-----------------|------------|---------|---------|---------|---------|---------
| aacLc       *   | ✔️ 2      |         |          |         |         |  
| pcm16bits       | ✔️ 2      |  ✔️    |   ✔️    |  ✔️     | ✔️     | ✔️

\* AAC is streamed with raw AAC with ADTS headers, so it's directly readable through a file!  
1. Bluetooth telephony device link (SCO) is automatically done but there's no phone call management.
2. Unsupported on legacy Android recorder.
3. Stream mode only.
4. Opus in CAF container. This means that your file will be playable only on iOS platforms.

## Usage

```dart
import 'package:record/record.dart';

final record = AudioRecorder();

// Check and request permission if needed
if (await record.hasPermission()) {
  // Start recording to file
  await record.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
  // ... or to stream
  final stream = await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
}

// Stop recording...
final path = await record.stop();
// ... or cancel it (and implicitly remove file/blob).
await record.cancel();

record.dispose(); // As always, don't forget this one.
```

## Background Recording

The package supports background recording for Android and iOS:

### Android Background Recording

```dart
import 'package:record/record.dart';

final record = AudioRecorder();

// Configure background recording for Android
const config = RecordConfig(
  androidConfig: AndroidRecordConfig(
    enableBackgroundRecording: true,
    notificationTitle: "Recording audio in background",
    notificationText: "Tap to open app",
    notificationIcon: "ic_microphone", // Optional: custom notification icon
  ),
);

// Start background recording
if (await record.hasPermission()) {
  await record.start(config, path: 'aFullPath/myFile.m4a');
  // Recording will continue even when app is minimized or killed
}
```

**Required Android Setup:**
1. Add permissions to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
   <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE" />
   ```

### iOS Background Recording

```dart
import 'package:record/record.dart';

final record = AudioRecorder();

// Configure background recording for iOS
const config = RecordConfig(
  iosConfig: IosRecordConfig(
    enableBackgroundRecording: true,
    categoryOptions: [
      IosAudioCategoryOption.allowBluetooth,
      IosAudioCategoryOption.defaultToSpeaker,
    ],
  ),
);

// Start background recording
if (await record.hasPermission()) {
  await record.start(config, path: 'aFullPath/myFile.m4a');
  // Recording will continue when app is minimized
}
```

**Required iOS Setup:**
1. Add background mode to `ios/Runner/Info.plist`:
   ```xml
   <key>UIBackgroundModes</key>
   <array>
     <string>audio</string>
   </array>
   ```

## Setup, permissions and others

### Android
[Setup](https://github.com/llfbandit/record/blob/master/record_android/README.md).

- min SDK: 23 (amrNb/amrWb: 26, Opus: 29)

### iOS
Add this to the ios/Runner/Info.plist file:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Some message to describe why you need this permission</string>
```
- min SDK: 12.0

### macOS
Add this to the macos/Runner/Info.plist file:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Some message to describe why you need this permission</string>
```

- In capabilities, activate "Audio input" in debug AND release schemes.  
- or directly in *.entitlements files
```xml
<key>com.apple.security.device.audio-input</key>
<true/>
```

- min SDK: 10.15
