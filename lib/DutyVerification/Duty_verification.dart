import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/Missing_Claim.dart';
import 'package:mysis/DutyVerification/RaiseComplaintScreen/RaiseComplaint.dart';
import 'package:mysis/constants/app_colors.dart';

class DutyVerificationScreen extends StatefulWidget {
  const DutyVerificationScreen({super.key});

  @override
  State<DutyVerificationScreen> createState() => _DutyVerificationScreenState();
}

class _DutyVerificationScreenState extends State<DutyVerificationScreen> {
  int selectedDay = 11;

// User ne last date tak verify kiya hai
  int verifiedTillDay = 11;
  bool isMissingClaimCompleted = false;

  final int lastDay = 20;

  final List<Map<String, String>> dates = [
    {'day': '11', 'week': 'Fri'},
    {'day': '12', 'week': 'Sat'},
    {'day': '13', 'week': 'Sun'},
    {'day': '14', 'week': 'Mon'},
    {'day': '15', 'week': 'Tue'},
    {'day': '16', 'week': 'Wed'},
    {'day': '17', 'week': 'Thu'},
    {'day': '18', 'week': 'Fri'},
    {'day': '19', 'week': 'Sat'},
    {'day': '20', 'week': 'Sun'},
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
              padding: const EdgeInsets.only(
                left: 8,
                right: 16,
                top: 6,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BACK ARROW
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.red,
                        size: 21,
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // TITLE + MONTH
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duty Verification',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'September 2026',
                        style: TextStyle(
                          fontSize: 14,
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
        child: Column(
          children: [
            // ======================================================
            // MONTH + DATES
            // ======================================================

            Container(
              width: double.infinity,
              color: AppColors.white,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'September 2026',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 86,
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
                            setState(() {
                              // Sirf current verified date ya usse pichli
                              // verified date par hi ja sakte hain.
                              if (day <= verifiedTillDay) {
                                selectedDay = day;
                              }
                            });
                          },
                          child: SizedBox(
                            width: 61,
                            child: Column(
                              children: [
                                // DATE
                                Container(
                                  width: 58,
                                  height: 66,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.red
                                        : AppColors.grey50,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['day']!,
                                        style: TextStyle(
                                          fontSize: 21,
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
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppColors.white
                                              : AppColors.red800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // DOT
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

            // ======================================================
            // SELECTED DATE
            // ======================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
              color: AppColors.background,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Friday, ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: '11 September 2026',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ======================================================
            // CONTENT
            // ======================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  16,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // =================================================
                      // GREEN TOP BORDER
                      // =================================================

                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.green500,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          15,
                          16,
                          16,
                        ),
                        child: Column(
                          children: [
                            // =========================================
                            // WARNING BOX
                            // =========================================

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(
                                  color: AppColors.red100,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // WARNING ICON
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 1,
                                    ),
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      size: 30,
                                      color: AppColors.orange700,
                                    ),
                                  ),

                                  const SizedBox(width: 11),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Duty Out not recorded',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.red800,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'You did not mark Duty Out. '
                                          'Please mark Duty Out before '
                                          'leaving your shift. If you '
                                          'missed it, raise a Missing '
                                          'Claim.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.35,
                                            color: AppColors.red800,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'आपने Duty Out नहीं किया। '
                                          'शिफ्ट छोड़ने से पहले Duty Out '
                                          'ज़रूर करें। अगर छूट गया है, '
                                          'तो Missing Claim डालें।',
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // =========================================
                            // SHIFT
                            // =========================================

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '8 Hrs Noon',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'SIS GROUP ENTERPRISES LIMITED',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 3),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'PAT-UNT033865',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // =========================================
                            // POST NAME
                            // =========================================

                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 22,
                                  color: AppColors.red,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Post Name :',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'PAT-UNT033865',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 11),

                            // =========================================
                            // THREE TIME BOXES
                            // =========================================

                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _shiftTimingBox(),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  flex: 4,
                                  child: _timeBox(
                                    title: 'Duty In',
                                    time: '02:00 PM',
                                    background: AppColors.green100,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  flex: 4,
                                  child: _timeBox(
                                    title: 'Duty Out',
                                    time: '10:00 PM',
                                    background: AppColors.red100,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 17),

                            // =========================================
                            // STATUS
                            // =========================================

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 23,
                                    color: AppColors.green600,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'Status :',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Attendance verified',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.green700,
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
                ),
              ),
            ),

            // ======================================================
            // BOTTOM BUTTONS
            // ======================================================

            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(
                18,
                13,
                18,
                15,
              ),
              child: Column(
                children: [
                  // VERIFIED & NEXT
                  SizedBox(
                    width: double.infinity,
                    height: 52,
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
                        size: 22,
                      ),
                      label: const Text(
                        'VERIFIED & NEXT',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green600,
                        disabledBackgroundColor: AppColors.grey50,
                        foregroundColor: AppColors.white,
                        disabledForegroundColor: AppColors.textSecondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // MISSING CLAIM
                  SizedBox(
                    width: 270,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RaiseComplaintScreen(),
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
                        disabledBackgroundColor: AppColors.grey50,
                        foregroundColor: AppColors.white,
                        disabledForegroundColor: AppColors.textSecondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text(
                        'MISSING CLAIM',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedDay == lastDay && verifiedTillDay == lastDay) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Next screen
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 22,
                  ),
                  label: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green600,
                    foregroundColor: AppColors.white,
                    elevation: 0,
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
    );
  }

  // ==============================================================
  // SHIFT TIMING BOX
  // ==============================================================

  Widget _shiftTimingBox() {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shift Timing',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          FittedBox(
            child: Row(
              children: [
                Text(
                  '02:00 PM',
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '10:00 PM',
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

  // ==============================================================
  // DUTY IN / DUTY OUT BOX
  // ==============================================================

  Widget _timeBox({
    required String title,
    required String time,
    required Color background,
  }) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: background.withOpacity(0.35),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 13,
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
