import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/Duty_verification.dart';

import 'package:mysis/DutyVerification/SelectPostScreen.dart';
import 'package:mysis/DutyVerification/SelectShiftScreen.dart';
import 'package:mysis/DutyVerification/SelectUnitScreen.dart';
import 'package:mysis/constants/app_colors.dart';

class MissingClaimScreen extends StatefulWidget {
  const MissingClaimScreen({
    super.key,
  });

  @override
  State<MissingClaimScreen> createState() => _MissingClaimScreenState();
}

class _MissingClaimScreenState extends State<MissingClaimScreen> {
  String? unit;
  String? shift;
  String? post;
  String? selectedReason;

  TimeOfDay? dutyInTime;
  TimeOfDay? dutyOutTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey400,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.red,
            size: 19,
          ),
        ),
        title: Text(
          "Missing Claim",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // CLAIM DATE CARD
            // =====================================================

            _claimDateCard(),

            const SizedBox(height: 12),

            // =====================================================
            // UNIT + SHIFT + POST CARD
            // =====================================================

            _unitShiftPostCard(),

            const SizedBox(height: 12),

            // =====================================================
            // DUTY TIME CARD
            // =====================================================

            _dutyTimeCard(),

            const SizedBox(height: 12),

            // =====================================================
            // REASON FOR CLAIM
            // =====================================================

            _reasonCard(),

            const SizedBox(height: 20),

            // =====================================================
            // SUBMIT BUTTON
            // =====================================================

            _submitButton(),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // CLAIM DATE CARD
  // =============================================================

  Widget _claimDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TITLE ----------------

          Row(
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 19,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                "Claim Date",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---------------- DATE BOX ----------------

          Container(
            width: double.infinity,
            height: 78,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppColors.border,
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                // Calendar icon

                Icon(
                  Icons.calendar_month_outlined,
                  size: 27,
                  color: AppColors.textPrimary,
                ),

                const SizedBox(width: 13),

                // Date text

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Date (can't be changed)",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Saturday, 12 September 2026",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Lock icon

                Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // UNIT SHIFT POST CARD
  // =============================================================

  Widget _unitShiftPostCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        17,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TITLE ----------------

          Row(
            children: [
              Icon(
                Icons.business_outlined,
                size: 19,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                "Unit & Shift & Post Details",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =====================================================
          // UNIT
          // =====================================================

          _fieldTitle("Unit *"),

          const SizedBox(height: 7),

          _selectionBox(
            text: unit ?? "CHOOSE UNIT",
            icon: Icons.business_outlined,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SelectUnitScreen(),
                ),
              );

              if (result != null) {
                setState(() {
                  unit = result.toString();
                });
              }
            },
          ),

          const SizedBox(height: 13),

          // =====================================================
          // SHIFT
          // =====================================================

          _fieldTitle("Shift *"),

          const SizedBox(height: 7),

          _selectionBox(
            text: shift ?? "CHOOSE SHIFT",
            icon: Icons.access_time_outlined,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SelectShiftScreen(),
                ),
              );

              if (result != null) {
                setState(() {
                  shift = result.toString();
                });
              }
            },
          ),

          const SizedBox(height: 13),

          // =====================================================
          // POST
          // =====================================================

          _fieldTitle("Post *"),

          const SizedBox(height: 7),

          _selectionBox(
            text: post ?? "CHOOSE POST",
            icon: Icons.access_time_outlined,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SelectPostScreen(),
                ),
              );

              if (result != null) {
                setState(() {
                  post = result.toString();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DUTY TIME CARD
  // =============================================================

  Widget _dutyTimeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        15,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TITLE ----------------

          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 19,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                "Duty Time",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // =====================================================
          // DUTY IN
          // =====================================================

          _dutyTimeRow(
            title: "Duty Out Time *",
            subtitle: dutyInTime == null
                ? "Tap to pick time"
                : _formatTime(dutyInTime!),
            color: AppColors.green700,
            background: AppColors.green.withOpacity(0.15),
            onTap: () {
              _pickTime(isDutyIn: true);
            },
          ),

          const SizedBox(height: 9),

          // =====================================================
          // DUTY OUT
          // =====================================================

          _dutyTimeRow(
            title: "Duty Out time *",
            subtitle: dutyOutTime == null
                ? "Tap to pick time"
                : _formatTime(dutyOutTime!),
            color: AppColors.red700,
            background: AppColors.red.withOpacity(0.10),
            onTap: () {
              _pickTime(isDutyIn: false);
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DUTY TIME ROW
  // =============================================================

  Widget _dutyTimeRow({
    required String title,
    required String subtitle,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // LEFT ICON

            Icon(
              Icons.access_time_outlined,
              size: 25,
              color: color,
            ),

            const SizedBox(width: 12),
            // TEXT


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // RIGHT CLOCK

            Icon(
              Icons.access_time_outlined,
              size: 28,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
// REASON FOR CLAIM
// =============================================================

  Widget _reasonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= TITLE =================

          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 19,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                "REASON FOR CLAIM",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ================= DROPDOWN =================

          DropdownButtonFormField<String>(
            value: selectedReason,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: "Choose reason",
              hintStyle: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.background,
              prefixIcon: Icon(
                Icons.description_outlined,
                color: AppColors.textPrimary,
                size: 21,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.red,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: "Duty Out not marked",
                child: Text(
                  "Duty Out not marked",
                ),
              ),
              DropdownMenuItem(
                value: "Duty In not marked",
                child: Text(
                  "Duty In not marked",
                ),
              ),
              DropdownMenuItem(
                value: "Attendance not updated",
                child: Text(
                  "Attendance not updated",
                ),
              ),
              DropdownMenuItem(
                value: "Biometric issue",
                child: Text(
                  "Biometric issue",
                ),
              ),
              DropdownMenuItem(
                value: "Device issue",
                child: Text(
                  "Device issue",
                ),
              ),
              DropdownMenuItem(
                value: "Network issue",
                child: Text(
                  "Network issue",
                ),
              ),
              DropdownMenuItem(
                value: "Other",
                child: Text(
                  "Other",
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedReason = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SUBMIT BUTTON
  // =============================================================

  // =============================================================
// SUBMIT BUTTON
// =============================================================

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {

          if (unit == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please choose unit"),
              ),
            );
            return;
          }

          if(shift== null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please choose Shift"),
              )
            );

          }


          if(post == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pleasen choose Post"),
              )
            );
          }
          if(selectedReason == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please choose reason for claim"),
                )
            );
          return;
          // Submit logic
        }
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DutyVerificationScreen(),
        ),
      );
    },





      // 🔥 LEFT SIDE ICON
        icon: Icon(
          Icons.send_outlined,
          size: 20,
          color: AppColors.white,
        ),

        // 🔥 BUTTON TEXT
        label: const Text(
          "SUBMIT MISSING CLAIM",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // FIELD TITLE
  // =============================================================

  Widget _fieldTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  // =============================================================
  // SELECTION BOX
  // =============================================================

  Widget _selectionBox({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.textPrimary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 23,
              color: AppColors.textPrimary,
            ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 23,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // TIME PICKER
  // =============================================================

  Future<void> _pickTime({
    required bool isDutyIn,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isDutyIn
          ? (dutyInTime ??
              const TimeOfDay(
                hour: 14,
                minute: 0,
              ))
          : (dutyOutTime ??
              const TimeOfDay(
                hour: 22,
                minute: 0,
              )),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isDutyIn) {
        dutyInTime = picked;
      } else {
        dutyOutTime = picked;
      }
    });
  }

  // =============================================================
  // FORMAT TIME
  // =============================================================

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? "AM" : "PM";

    return "$hour:$minute $period";
  }
}
