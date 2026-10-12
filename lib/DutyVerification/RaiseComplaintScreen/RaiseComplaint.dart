import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/ComplaintDateCard.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/ComplaintDetailsCard.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/SubmitComplaintButton.dart';
import 'package:mysis/constants/app_colors.dart';

import '../repo/ComplaintApiService.dart';
import 'VoiceNoteCard.dart';

/// Equivalent of RaiseComplaintFragment.newInstance(dateLabel, apiDate, attendanceId)
/// Pops with `true` when the complaint is submitted (replaces
/// MissingClaimSubmitInterface.onRecordSubmitted).
class RaiseComplaintScreen extends StatefulWidget {
  final String apiDate;
  final String attendanceId;

  const RaiseComplaintScreen({
    super.key,
    required this.apiDate,
    required this.attendanceId,
  });

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final TextEditingController _descController = TextEditingController();

  int? _categoryIndex; // 1-based, matches Android spinner position
  String? _voicePath;
  bool _isSubmitting = false;
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d MMMM yyyy').format(parsedDate);
  }
  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: const Color(0xFFDC2626)),
      );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (_categoryIndex == null) {
      _showError('select_category_error'.tr());
      return;
    }

    final desc = _descController.text.trim();
    final hasText = desc.length >= 10;
    final hasAudio = _voicePath != null;

    if (!hasText && !hasAudio) {
      _showError('describe_issue_error'.tr());
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final result = await ComplaintApiService.submitComplaint(
      attendanceId: widget.attendanceId,
      remark: desc,
      categoryIndex: _categoryIndex!,
      voicePath: _voicePath,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    print('fdjhhgdgjhvjhgjgh${result.success}');

    if (result.success) {
      print('fdjhhgdgjhvjhgjgh');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('complaint_submitted_success'.tr()),
          backgroundColor: const Color(0xFF16A34A),
        ),
      );
      Navigator.pop(context, true);
    } else {
      _showError(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        title: Text(
          'raise_complaint'.tr(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ComplaintDateCard(dateLabel: formatDate(widget.apiDate)),
              const SizedBox(height: 16),
              ComplaintDetailsCard(
                descriptionController: _descController,
                selectedCategory: _categoryIndex,
                onCategoryChanged: (v) => setState(() => _categoryIndex = v),
              ),
              const SizedBox(height: 16),
              VoiceNoteCard(
                onChanged: (path) => _voicePath = path,
              ),
              const SizedBox(height: 20),
              SubmitComplaintButton(
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}