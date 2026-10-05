import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mysis/constants/app_colors.dart';
import 'package:record/record.dart';

class VoiceNoteCard extends StatefulWidget {
  const VoiceNoteCard({super.key});

  @override
  State<VoiceNoteCard> createState() => _VoiceNoteCardState();
}

class _VoiceNoteCardState extends State<VoiceNoteCard> {
  final _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isRecording = false;
  bool voiceNoteSaved = false;
  bool isPlaying = false;

  String? audioPath;

  @override
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

// =========================
// START / STOP RECORDING
// =========================

  Future<void> _recordVoiceNote() async {
    if (isRecording) {
// STOP RECORDING
      final path = await _recorder.stop();

      if (path != null) {
        setState(() {
          isRecording = false;
          voiceNoteSaved = true;
          audioPath = path;
        });
      }

      return;
    }

// Microphone permission check
    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Microphone permission is required"),
        ),
      );
      return;
    }

// File location
    final directory = await getTemporaryDirectory();

    final filePath =
        '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

// START RECORDING
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
      ),
      path: filePath,
    );

    setState(() {
      isRecording = true;
      voiceNoteSaved = false;
    });
  }

// =========================
// PLAY AUDIO
// =========================

  Future<void> _playAudio() async {
    if (audioPath == null) {
      return;
    }

    if (isPlaying) {
      await _audioPlayer.pause();

      setState(() {
        isPlaying = false;
      });

      return;
    }

    await _audioPlayer.play(
      DeviceFileSource(audioPath!),
    );

    setState(() {
      isPlaying = true;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
// =========================
// TITLE
// =========================

          Row(
            children: const [
              Icon(
                Icons.mic_none,
                color: AppColors.red700,
                size: 22,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'VOICE NOTE (Optional — or use text above)',
                  style: TextStyle(
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

          const Text(
            'Voice Note Tip: Keep it short & to the point (under 30 sec)',
            style: TextStyle(
              color: AppColors.blue700,
              fontSize: 13,
            ),
          ),



          const SizedBox(height: 18),

// =========================
// STATUS
// =========================

          Text(
            isRecording
                ? '🔴 Recording...'
                : voiceNoteSaved
                    ? '✓ Voice note saved'
                    : 'Tap to start recording',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 16),

// =========================
// BUTTONS
// =========================

          Row(
            children: [
// RECORD BUTTON
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _recordVoiceNote,
                    icon: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                    ),
                    label: Text(
                      isRecording
                          ? 'STOP RECORDING'
                          : voiceNoteSaved
                              ? 'RE-RECORD'
                              : 'RECORD VOICE NOTE',
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

// PLAY BUTTON
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: voiceNoteSaved ? _playAudio : null,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(
                      isPlaying ? 'PAUSE' : 'PLAY BACK',
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
