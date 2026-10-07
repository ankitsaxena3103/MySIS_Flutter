import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/ComplaintDateCard.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/ComplaintDetailsCard.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/SubmitComplaintButton.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/VoiceNoteCard.dart';
import 'package:mysis/constants/app_colors.dart';



class RaiseComplaintScreen extends StatelessWidget {
  const RaiseComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              const ComplaintDateCard(),

              const SizedBox(height: 16),

              const ComplaintDetailsCard(),

              const SizedBox(height: 16),

              const VoiceNoteCard(),

              const SizedBox(height: 20),

              const SubmitComplaintButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}