package com.llfbandit.record.record

import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.media.MediaRecorder

class RecordConfig(
    val path: String?,
    val encoder: String,
    val bitRate: Int,
    val sampleRate: Int,
    numChannels: Int,
    val device: AudioDeviceInfo?,
    val autoGain: Boolean = false,
    val echoCancel: Boolean = false,
    val noiseSuppress: Boolean = false,
    val useLegacy: Boolean = false,
    val muteAudio: Boolean = false,
    val manageBluetooth: Boolean = true,
    val audioSource: Int = MediaRecorder.AudioSource.DEFAULT,
    val speakerphone: Boolean = false,
    val audioManagerMode: Int = AudioManager.MODE_NORMAL,
    val enableBackgroundRecording: Boolean = false,
    val notificationTitle: String = "Recording audio",
    val notificationText: String = "Audio recording is active",
    val notificationIcon: String? = null
) {
    val numChannels: Int = 2.coerceAtMost(1.coerceAtLeast(numChannels))
}

class AudioEncoder {
    companion object {
        const val aacLc = "aacLc"
        const val aacEld = "aacEld"
        const val aacHe = "aacHe"
        const val amrNb = "amrNb"
        const val amrWb = "amrWb"
        const val flac = "flac"
        const val pcm16bits = "pcm16bits"
        const val opus = "opus"
        const val wav = "wav"
    }
}
