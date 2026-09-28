import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';


class VoiceNoteCard extends StatefulWidget {
  const VoiceNoteCard({super.key});

  @override
  State<VoiceNoteCard> createState() => _VoiceNoteCardState();
}

class _VoiceNoteCardState extends State<VoiceNoteCard> {
  bool isRecording = false;
  bool voiceNoteSaved = false;

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
          Text(
            voiceNoteSaved
                ? '✓ Voice note saved (18s)'
                : 'Tap to start recording',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isRecording = !isRecording;

                        if (!isRecording) {
                          voiceNoteSaved = true;
                        }
                      });
                    },
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
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: voiceNoteSaved
                        ? () {
                            // Audio playback later
                          }
                        : null,
                    icon: const Icon(
                      Icons.play_arrow,
                    ),
                    label: const Text(
                      'PLAY BACK',
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
