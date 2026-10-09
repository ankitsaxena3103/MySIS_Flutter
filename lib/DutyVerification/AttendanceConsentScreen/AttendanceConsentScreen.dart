import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import '../../CommonViews/Utility.dart';
import '../../SharedClasses/Preferences.dart';
import '../repo/ConsentUploadService.dart';
import 'SignatureScreenFile.dart';

class AttendanceConsentScreen extends StatefulWidget {
  String?startDate;
  String?endDate;

  AttendanceConsentScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });
  @override
  State<AttendanceConsentScreen> createState() =>
      _AttendanceConsentScreenState();
}

class _AttendanceConsentScreenState extends State<AttendanceConsentScreen> {
  // ==========================================================
  // SIGNATURE
  // ==========================================================

  final List<Offset?> _signaturePoints = [];
  File? _signatureFile;
  DateTime? _signedAt;
  bool _isSigned = false;

  // true while the full page is being captured (hides Submit / Clear)
  bool _isCapturing = false;
  bool _isSubmitting = false;

  final GlobalKey _consentKey = GlobalKey();
  final GlobalKey _signatureKey = GlobalKey();

  // ==========================================================
  // EMPLOYEE DETAILS
  // ==========================================================

  String employeeName = "";
  String registrationNo = "";
  String period = "";

  List<ui.Offset?>? get savedSignature => null;

  Future<void> _openSignatureScreen() async {
    final File? result = await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (_) => const SignatureScreenFile()),
    );

    if (result != null) {
      // delete the old file to avoid piling up storage
      if (_signatureFile != null && await _signatureFile!.exists()) {
        await _signatureFile!.delete();
      }
      setState(() {
        _signatureFile = result;
        _signedAt = DateTime.now();
        _isSigned = true;
      });
    }
  }

  /// Captures the COMPLETE consent page (not just the visible part),
  /// same as captureFullScrollView() in ConsentLetterActivity.kt.
  Future<Uint8List?> _captureConsentScreen() async {
    try {
      final ctx = _consentKey.currentContext;
      if (ctx == null) return null;

      final RenderRepaintBoundary boundary =
      ctx.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Capture Error: $e");
      return null;
    }
  }

  /// Equivalent of onSubmit() + captureAndUpload() in the Kotlin activity.
  Future<void> _onSubmit() async {
    if (_isSubmitting) return;

    if (!_isSigned || _signatureFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete your signature first")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _isCapturing = true; // hides Submit + Clear (native: submitBtn GONE)
    });

    try {
      // wait until the button is really removed from the tree, then paint
      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 50));

      final Uint8List? png = await _captureConsentScreen();

      if (mounted) setState(() => _isCapturing = false);

      if (png == null) throw Exception('Could not capture consent page');

      final result = await ConsentUploadService.submit(

        png: png,
        mContext: context,
        regNo: registrationNo,
        fromDate: widget.startDate ?? '',
        toDate: widget.endDate ?? '',
      );

      if (!mounted) return;

      if (result.success) {
        // TODO: mark local duty-verification record complete here
        // (native: flashMessageDao -> IS_VERIFICATION_COMPLETE = 1)
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            content: const Text('Consent submitted successfully'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (!mounted) return;
        Navigator.pop(context, 'COMPLETED'); // native: SIGNATURE_STATUS
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      debugPrint('Submit error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submit failed, please try again')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // APP BAR
            // ==================================================

            _appBar(),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  key: _consentKey,
                  child: Container(
                    color: AppColors.white, // opaque bg for the screenshot
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // ==================================================
                          // LOGO
                          // ==================================================

                          _logoSection(),

                          const SizedBox(height: 8),

                          // ==================================================
                          // DATE
                          // ==================================================

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Date / दिनांक : ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ==================================================
                          // TITLE
                          // ==================================================

                          _title(),

                          const SizedBox(height: 14),

                          // ==================================================
                          // INTRO
                          // ==================================================

                          _introText(),

                          const SizedBox(height: 14),

                          // ==================================================
                          // EMPLOYEE TABLE
                          // ==================================================

                          _employeeTable(),

                          const SizedBox(height: 18),

                          // ==================================================
                          // POINT 1
                          // ==================================================

                          _consentRow(
                            number: "1",
                            english:  "I confirm that my attendance for the above-mentioned period is completely correct and accurate.",

                            hindi:
                            'attendance_declaration_1'.tr(),
                          ),

                          _divider(),

                          // ==================================================
                          // POINT 2
                          // ==================================================

                          _consentRow(
                            number: "2",
                            english:
                            "Other than the attendance claim submitted by me, which is pending for approval with the concerned authority, no other missing attendance claim or attendance-related claim is pending.",
                            hindi: 'attendance_declaration_2'.tr(),
                          ),

                          _divider(),

                          // ==================================================
                          // POINT 3
                          // ==================================================

                          _consentRow(
                            number: "3",
                            english:
                            "I also agree that my salary generation process may be continued based on the above attendance.",
                            hindi:
                            'attendance_declaration_3'.tr(),
                          ),

                          _divider(),

                          // ==================================================
                          // POINT 4
                          // ==================================================

                          _consentRow(
                            number: "4",
                            english: "I understand that if any information provided by me is found to be incorrect, appropriate action may be taken as per company policy.",
                            hindi:
                            'attendance_declaration_4.'.tr(),
                          ),

                          const SizedBox(height: 10),

                          // ==================================================
                          // FINAL DECLARATION
                          // ==================================================

                          _declaration(),

                          const SizedBox(height: 20),

                          // ==================================================
                          // SIGNATURE AREA
                          // ==================================================

                          _signatureSection(),

                          const SizedBox(height: 22),

                          // ==================================================
                          // SUBMIT BUTTON
                          // ==================================================

                          _submitButton(),

                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // APP BAR
  // ==============================================================

  Widget _appBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 19,
              color: AppColors.red,
            ),
          ),
          Text(
            'attendance_verification'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // LOGO SECTION
  // ==============================================================

  Widget _logoSection() {
    return Column(
      children: [
        SizedBox(
          height: 76,
          child: Row(
            children: [
              Expanded(
                child: Image.asset(
                  "assets/images/icons/SIS-logo.png",
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 55,
                child: Image.asset(
                  "assets/images/icons/icon.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          width: double.infinity,
          color: AppColors.red,
        ),
      ],
    );
  }

  // ==============================================================
  // TITLE
  // ==============================================================

  Widget _title() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      color: AppColors.background,
      child: Column(
        children: [
          Text(
            "Attendance Verification & Consent",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'attendance_verification_consent'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // INTRO TEXT
  // ==============================================================

  Widget _introText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I, the undersigned, confirm and declare the following regarding my attendance for the period mentioned below.",

          style: TextStyle(
            fontSize: 14,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'attendance_declaration_6'.tr(),
          style: TextStyle(
            fontSize: 13.5,
            height: 1.3,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // EMPLOYEE TABLE
  // ==============================================================

  Widget _employeeTable() {
    return Table(
      border: TableBorder.all(
        color: AppColors.textPrimary,
        width: 0.7,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.1),
        1: FlexColumnWidth(1.5),
      },
      children: [
        _tableRow(
          "Name / नाम",
          employeeName,
        ),
        _tableRow(
          "Reg No / रजि. नं.",
          registrationNo,
        ),
        _tableRow(
          "Period / अवधि",
          period,
        ),
      ],
    );
  }

  TableRow _tableRow(
      String title,
      String value,
      ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // CONSENT ROW
  // ==============================================================

  // ==============================================================
// CONSENT ROW
// ==============================================================

  Widget _consentRow({
    required String number,
    required String english,
    required String hindi,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // NUMBER BOX
          // ========================================================

          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // ENGLISH
          // ========================================================

          Expanded(
            child: Text(
              english,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // ========================================================
          // CENTER DIVIDER
          // ========================================================

          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            color: AppColors.border,
          ),

          // ========================================================
          // HINDI
          // ========================================================

          Expanded(
            child: Text(
              hindi,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // DIVIDER
  // ==============================================================

  Widget _divider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.border,
    );
  }

  // ==============================================================
  // DECLARATION
  // ==============================================================

  Widget _declaration() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          color: AppColors.red,
          child: Icon(
            Icons.check,
            size: 15,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Therefore, I declare that the above statements are true and correct to the best of my knowledge and belief.",
                style: TextStyle(
                  fontSize: 11.8,
                  height: 1.25,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'attendance_declaration_5'.tr(),
                style: TextStyle(
                  fontSize: 11.8,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // SIGNATURE SECTION
  // ==============================================================

  Widget _signatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------------
        // SIGNATURE BOX
        // ----------------------------------------------------------

        // Container(
        //   width: double.infinity,
        //   height: 100,
        //   decoration: BoxDecoration(
        //     color: AppColors.white,
        //     border: Border.all(
        //       color: AppColors.border,
        //       width: 0.8,
        //     ),
        //     borderRadius: BorderRadius.circular(6),
        //   ),
        //   child: Stack(
        //     children: [
        //       // ==============================================
        //       // SIGNATURE CANVAS
        //       // ==============================================
        //
        //       // ==============================================
        //       // DATE / TIME
        //       // ==============================================
        //
        //       Positioned(
        //         right: 10,
        //         bottom: 12,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: [
        //             Text(
        //               "23 Sep 2026 13:27",
        //               style: TextStyle(
        //                 fontSize: 10,
        //                 fontWeight: FontWeight.w700,
        //                 color: AppColors.textPrimary,
        //               ),
        //             ),
        //             const SizedBox(height: 3),
        //             Text(
        //               "Date / दिनांक",
        //               style: TextStyle(
        //                 fontSize: 9.5,
        //                 fontWeight: FontWeight.w600,
        //                 color: AppColors.textPrimary,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //
        //       // ==============================================
        //       // SIGN HERE TEXT
        //       // ==============================================
        //
        //       if (!_isSigned)
        //         Positioned(
        //           left: 15,
        //           bottom: 10,
        //           child: Text(
        //             "Sign here / यहाँ हस्ताक्षर करें",
        //             style: TextStyle(
        //               fontSize: 9,
        //               color: AppColors.textSecondary,
        //             ),
        //           ),
        //         ),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const Text('Signature / हस्ताक्षर',
        //           style: TextStyle(fontWeight: FontWeight.w600)),
        //       const SizedBox(height: 8),
        //
        //       GestureDetector(
        //         onTap: _openSignatureScreen,
        //         child: Container(
        //           height: 150,
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             border: Border.all(color: Colors.grey.shade400),
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //           child: _signatureFile == null
        //               ? const Center(
        //             child: Text('Tap to sign / हस्ताक्षर करने के लिए टैप करें'),
        //           )
        //               : Padding(
        //             padding: const EdgeInsets.all(8),
        //             child: Image.file(
        //               _signatureFile!,
        //               fit: BoxFit.contain,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: _openSignatureScreen,
            child: Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                children: [
                  // Signature area (takes all remaining space)
                  Expanded(
                    child: Center(
                      child: _signatureFile == null
                          ? const SizedBox.shrink()
                          : Image.file(_signatureFile!, fit: BoxFit.contain),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Footer row: labels never overlap because each side is flexible
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left: Sign here
                      Expanded(
                        flex: 5,
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.3),
                            children: [
                              TextSpan(
                                text: 'Sign here /\n',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: 'यहाँ हस्ताक्षर करें'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right: Date value + label
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                DateFormat('dd MMM yyyy HH:mm')
                                    .format(_signedAt ?? DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              textAlign: TextAlign.right,
                              text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.3),
                                children: [
                                  TextSpan(
                                    text: 'Date / ',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: 'दिनांक'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),

        // ----------------------------------------------------------
        // SIGNATURE LABEL
        // ----------------------------------------------------------

        if (_isSigned && !_isCapturing)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _signaturePoints.clear();
                  _signatureFile = null;
                  _signedAt = null;
                  _isSigned = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Text(
                  "CLEAR SIGNATURE",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==============================================================
  // SUBMIT BUTTON
  // ==============================================================

  Widget _submitButton() {
    // removed from the layout while capturing so it is not in the image
    if (_isCapturing) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          'submit_consent'.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
    final name =
        await Preferences.getUserPreference(keyUserName) ?? '';

    final regNo =
        await Preferences.getUserPreference(keyUserID) ?? '';

    if (!mounted) return;

    setState(() {
      employeeName = name;
      registrationNo = regNo;
      period = formatPeriod(
        widget.startDate ?? '',
        widget.endDate ?? '',
      );    });
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();

  }
  String formatPeriod(String startDate, String endDate) {

    if (startDate.isEmpty || endDate.isEmpty) {
      return '';
    }
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);

    final startFormatted = DateFormat('dd MMM').format(start);
    final endFormatted = DateFormat('dd MMM yy').format(end);

    return '$startFormatted - $endFormatted';
  }
}