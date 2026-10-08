import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/DutySummaryModule/DutySummaryScreen.dart';
import 'package:mysis/DutyVerification/Missing_Claim.dart';
import 'package:mysis/constants/app_colors.dart';

class DutyVerificationScreen extends StatefulWidget {
  const DutyVerificationScreen({super.key});

  @override
  State<DutyVerificationScreen> createState() => _DutyVerificationScreenState();
}

class _DutyVerificationScreenState extends State<DutyVerificationScreen> {
  int selectedDay = 21;
  int verifiedTillDay = 21;

  bool isMissingClaimCompleted = false;

  final int lastDay = 27;

  final List<Map<String, String>> dates = [
    {'day': '21', 'week': 'Mon'},
    {'day': '22', 'week': 'Tue'},
    {'day': '23', 'week': 'Wed'},
    {'day': '24', 'week': 'Thu'},
    {'day': '25', 'week': 'Fri'},
    {'day': '26', 'week': 'Sat'},
    {'day': '27', 'week': 'Sun'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: AppColors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'duty_verification'.tr(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'September 2026',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ========================================================
            // MONTH + DATE
            // ========================================================
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.only(
                top: 6,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Text(
                    'September 2026',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 72,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final item = dates[index];

                        final int day = int.parse(item['day']!);

                        final bool isSelected = selectedDay == day;

                        return GestureDetector(
                          onTap: () {
                            if (day <= verifiedTillDay) {
                              setState(() {
                                selectedDay = day;
                              });
                            }
                          },
                          child: SizedBox(
                            width: 61,
                            child: Column(
                              children: [
                                Container(
                                  width: 58,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.red
                                        : AppColors.grey50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['day']!,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? AppColors.white
                                              : AppColors.red800,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item['week']!,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppColors.white
                                              : AppColors.red800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppColors.green500
                                        : AppColors.orange700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 1,
                    color: AppColors.divider,
                  ),
                ],
              ),
            ),

            // ========================================================
            // SELECTED DATE
            // ========================================================
            Container(
              width: double.infinity,
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                10,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Monday, ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: '21 September 2026',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ========================================================
            // MAIN CONTENT
            // ========================================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  3,
                  16,
                  14,
                ),
                child: _mainDutyCard(),
              ),
            ),

            // ========================================================
            // BOTTOM BUTTONS
            // ========================================================
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                13,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: selectedDay == verifiedTillDay
                          ? () {
                              if (verifiedTillDay < lastDay) {
                                setState(() {
                                  verifiedTillDay++;
                                  selectedDay = verifiedTillDay;
                                });
                              }
                            }
                          : null,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 20,
                      ),
                      label: Text(
                        'verified_next'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green600,
                        disabledBackgroundColor: AppColors.grey50,
                        foregroundColor: AppColors.white,
                        disabledForegroundColor: AppColors.textSecondary,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: 270,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MissingClaimScreen(),
                          ),
                        );

                        if (result == true) {
                          setState(() {
                            isMissingClaimCompleted = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange700,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(
                        'missing_claim'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  if (selectedDay == lastDay && verifiedTillDay == lastDay) ...[
                    const SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DutySummaryScreen(
                                user: "AGR002430",
                                deviceToken: "",
                                password: "5054",
                                mPin: "5054",
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 21,
                        ),
                        label: Text(
                          'Duty_Verification_continue'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // MAIN DUTY CARD
  // ==============================================================
// =============================================================
// MAIN DUTY CARD
// =============================================================

  Widget _mainDutyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // =========================================================
          // GREEN TOP LINE
          // =========================================================

          Container(
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.green500,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
          ),

          // =========================================================
          // WARNING
          // =========================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              12,
              12,
              0,
            ),
            child: _warningCard(),
          ),

          // =========================================================
          // DUTY INFORMATION
          // =========================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              13,
              14,
              13,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===================================================
                // 8 HRS NOON + SHIFT TIMING
                // ===================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SIDE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '8 Hrs Noon',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'SIS GROUP ENTERPRISES LIMITED',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'PAT-UNT033865',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // RIGHT SIDE - SHIFT TIMING
                    SizedBox(
                      width: 170,
                      child: _shiftTimingBox(
                        start: '02:00 PM',
                        end: '10:00 PM',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ===================================================
                // POST NAME
                // ===================================================

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Post Name :',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'IT Cell',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ===================================================
                // APPROVED HOUR + DUTY IN + DUTY OUT
                // ===================================================

                Row(
                  children: [
                    // APPROVED HOUR
                    Expanded(
                      child: _approvedHourBox(),
                    ),

                    const SizedBox(width: 7),

                    // DUTY IN
                    Expanded(
                      child: _timeBox(
                        title: 'Duty In'.tr(),
                        time: '02:00 PM',
                        background: AppColors.green100,
                        titleColor: AppColors.green700,
                      ),
                    ),

                    const SizedBox(width: 7),

                    // DUTY OUT
                    Expanded(
                      child: _timeBox(
                        title: 'Duty Out'.tr(),
                        time: '10:00 PM',
                        background: AppColors.red100,
                        titleColor: AppColors.red700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 11),

                // ===================================================
                // STATUS
                // ===================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green100.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 21,
                        color: AppColors.green600,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'status_tag. :'.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'attendance_verified'.tr(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // WARNING CARD
  // ==============================================================

  Widget _warningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.red100.withOpacity(0.28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.red100,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 28,
            color: AppColors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'duty_out_not_recorded'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'duty_out_not_recorded_message'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.red800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'late_duty_in_duty_out_not_recorded'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.red800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // SHIFT TIMING
  // ==============================================================

  Widget _shiftTimingBox({
    required String start,
    required String end,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBlueGray,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'shift_timing'.tr(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          FittedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  start,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green600,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '-',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  end,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// =============================================================
// APPROVED HOUR
// =============================================================

  Widget _approvedHourBox() {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBlueGray,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Approved_Hour'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '0',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // DUTY IN / DUTY OUT
  // ==============================================================

  Widget _timeBox({
    required String title,
    required String time,
    required Color background,
    required Color titleColor,
  }) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: background.withOpacity(0.40),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
