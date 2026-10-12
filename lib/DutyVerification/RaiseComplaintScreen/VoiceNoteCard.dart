import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceNoteCard extends StatefulWidget {
  /// Called with the recorded file path (or null if removed / re-recording).
  final ValueChanged<String?> onChanged;

  const VoiceNoteCard({super.key, required this.onChanged});

  @override
  State<VoiceNoteCard> createState() => _VoiceNoteCardState();
}

class _VoiceNoteCardState extends State<VoiceNoteCard> {
  static const int maxRecordSeconds = 60;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription<void>? _completeSub;
  Timer? _timer;

  bool isRecording = false;
  bool voiceNoteSaved = false;
  bool isPlaying = false;
  int recordSeconds = 0;

  String? audioPath;

  @override
  void initState() {
    super.initState();
    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => isPlaying = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _completeSub?.cancel();
    _recorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ───────── RECORD ─────────

  Future<void> _recordVoiceNote() async {
    if (isRecording) {
      await _stopRecording();
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (mounted) _toast('microphone_permission_required'.tr());
      return;
    }

    try {
      // stop any playback before recording
      await _audioPlayer.stop();

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/complaint_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );

      if (!mounted) return;
      setState(() {
        isRecording = true;
        voiceNoteSaved = false;
        isPlaying = false;
        recordSeconds = 0;
      });
      widget.onChanged(null);

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        setState(() => recordSeconds++);
        if (recordSeconds >= maxRecordSeconds) {
          _stopRecording();
        }
      });
    } catch (e) {
      if (mounted) _toast('Could not start recording. Check microphone permissions.');
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    String? path;
    try {
      path = await _recorder.stop();
    } catch (_) {}

    if (!mounted) return;

    if (path != null && await File(path).exists()) {
      setState(() {
        isRecording = false;
        voiceNoteSaved = true;
        audioPath = path;
      });
      widget.onChanged(path);
    } else {
      setState(() => isRecording = false);
      widget.onChanged(null);
    }
  }

  // ───────── PLAY ─────────

  Future<void> _playAudio() async {
    if (audioPath == null) return;

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        setState(() => isPlaying = false);
        return;
      }
      await _audioPlayer.play(DeviceFileSource(audioPath!));
      setState(() => isPlaying = true);
    } catch (_) {
      _toast('Could not play recording.');
    }
  }

  String get _statusText {
    if (isRecording) {
      return '🔴 ${'recording'.tr()} $recordSeconds s / $maxRecordSeconds s';
    }
    if (voiceNoteSaved) {
      return '✓ ${'voice_note_saved'.tr()} ($recordSeconds s)';
    }
    return 'tap_to_start_recording'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mic_none, color: AppColors.red700, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'voice_note_optional'.tr(),
                  style: const TextStyle(
                    color: AppColors.red700,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'voice_note_tip'.tr(),
            style: const TextStyle(color: AppColors.blue700, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Text(
            _statusText,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _recordVoiceNote,
                    icon: Icon(isRecording ? Icons.stop : Icons.mic),
                    label: Text(
                      isRecording
                          ? 'stop_recording'.tr()
                          : voiceNoteSaved
                          ? 're_record'.tr()
                          : 'record_voice_note'.tr(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red700,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: voiceNoteSaved && !isRecording ? _playAudio : null,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(
                      isPlaying ? 'pause'.tr() : 'play_back'.tr(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueGrey800,
                      disabledBackgroundColor: AppColors.disabledColor,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}