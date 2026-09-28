import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mysis/DutyVerification/AttendanceConsentScreen/AttendanceConsentPdf.dart';
import 'package:mysis/DutyVerification/AttendanceConsentScreen/SignaturePainter.dart';
import 'package:mysis/DutyVerification/DutySummaryScreen/DutySummaryScreen.dart';
import 'package:mysis/constants/app_colors.dart';
import 'package:flutter/services.dart';

import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';

class AttendanceConsentScreen extends StatefulWidget {
  const AttendanceConsentScreen({super.key});

  @override
  State<AttendanceConsentScreen> createState() =>
      _AttendanceConsentScreenState();
}

class _AttendanceConsentScreenState extends State<AttendanceConsentScreen> {
  // ==========================================================
  // SIGNATURE
  // ==========================================================

  final List<Offset?> _signaturePoints = [];

  bool _isSigned = false;

  final GlobalKey _consentKey = GlobalKey();
  final GlobalKey _signatureKey = GlobalKey();

  // ==========================================================
  // EMPLOYEE DETAILS
  // ==========================================================

  final String employeeName = "SAMANT KUMAR JAISWA";
  final String registrationNo = "PAT069548";
  final String period = "11 Sep - 20 Sep 26";

  List<ui.Offset?>? get savedSignature => null;

  Future<Uint8List?> _captureConsentScreen() async {
    try {
      final RenderRepaintBoundary boundary = _consentKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(
        pixelRatio: 3.0,
      );

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint(
        "Capture Error: $e",
      );

      return null;
    }
  }

  Future<void> _printConsent() async {
    try {
      final pdfBytes = await AttendanceConsentPdf.generatePdf(
        employeeName: employeeName,
        registrationNo: registrationNo,
        period: period,
        signaturePoints: savedSignature,
      );

      await Printing.layoutPdf(
        onLayout: (format) async {
          return pdfBytes;
        },
      );
    } catch (e) {
      debugPrint(
        "PDF Error: $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "PDF generation failed: $e",
          ),
        ),
      );
    }
  }

  Future<Uint8List?> _getSignatureImage() async {
    try {
      final boundary = _signatureKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;

      final image = await boundary.toImage(
        pixelRatio: 3.0,
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Signature Image Error: $e");
      return null;
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
              child: RepaintBoundary(
                key: _consentKey,
                child: SingleChildScrollView(
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
                            "Date / दिनांक : 23 Sep 2026",
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
                          english: "I verify that my attendance for the period "
                              "mentioned above is fully correct and accurate.",
                          hindi:
                              "मैं पुष्टि करता/करती हूँ कि उपर्युक्त अवधि की "
                              "मेरी उपस्थिति पूर्णतः सही और सटीक है।",
                        ),

                        _divider(),

                        // ==================================================
                        // POINT 2
                        // ==================================================

                        _consentRow(
                          number: "2",
                          english:
                              "Other than the claim of attendance submitted "
                              "by me, the acceptance of which is pending at "
                              "the level of the appropriate authority, no "
                              "other missing attendance claim or any other "
                              "claim related to attendance is pending.",
                          hindi: "मेरे द्वारा प्रस्तुत उपस्थिति दावे के अलावा, "
                              "जिसकी स्वीकृति संबंधित प्राधिकारी स्तर पर "
                              "लंबित है, कोई अन्य अनुपस्थित उपस्थिति दावा "
                              "या उपस्थिति से संबंधित कोई अन्य दावा लंबित नहीं है।",
                        ),

                        _divider(),

                        // ==================================================
                        // POINT 3
                        // ==================================================

                        _consentRow(
                          number: "3",
                          english:
                              "I further agree that on the basis of the said "
                              "attendance, the process of my salary generation "
                              "should be proceeded.",
                          hindi:
                              "मैं यह भी सहमत हूँ कि उपयुक्त उपस्थिति के आधार "
                              "पर मेरे वेतन निर्माण की प्रक्रिया आगे बढ़ाई जाए।",
                        ),

                        _divider(),

                        // ==================================================
                        // POINT 4
                        // ==================================================

                        _consentRow(
                          number: "4",
                          english: "I understand that in case any information "
                              "provided by me is found to be incorrect, I "
                              "shall be liable for appropriate action as "
                              "per company policy.",
                          hindi:
                              "मैं समझता/समझती हूँ कि यदि मेरे द्वारा प्रदान "
                              "की गई कोई भी जानकारी गलत पाई जाती है, तो मुझे "
                              "कंपनी की नीति के अनुसार उचित कार्रवाई के लिए "
                              "उत्तरदायी माना जाएगा।",
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
            "Attendance Verification",
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
            "उपस्थिति सत्यापन एवं सहमति पत्र",
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
          "I, the undersigned, hereby confirm and declare the "
          "following regarding my attendance for the period "
          "mentioned below.",
          style: TextStyle(
            fontSize: 14,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          "मैं, अधोहस्ताक्षरी, निम्नलिखित के संबंध में पुष्टि और घोषणा "
          "करता/करती हूँ कि मेरे द्वारा नीचे उल्लिखित अवधि की उपस्थिति "
          "के संबंध में निम्नलिखित कथन सत्य और सही हैं।",
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

  Widget _consentRow({
    required String number,
    required String english,
    required String hindi,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NUMBER
          Container(
            width: 23,
            height: 23,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 7),

          // ENGLISH
          Expanded(
            child: Text(
              english,
              style: TextStyle(
                fontSize: 11.8,
                height: 1.28,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // CENTER LINE
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            height: 95,
            color: AppColors.border,
          ),

          // HINDI
          Expanded(
            child: Text(
              hindi,
              style: TextStyle(
                fontSize: 11.8,
                height: 1.28,
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
                "I, therefore, declare that the above statements "
                "are true and correct to the best of my knowledge "
                "and belief.",
                style: TextStyle(
                  fontSize: 11.8,
                  height: 1.25,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "अतः, मैं घोषणा करता/करती हूँ कि उपयुक्त कथन मेरे "
                "ज्ञान और विश्वास के अनुसार सत्य और सही हैं।",
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

        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.border,
              width: 0.8,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              // ==============================================
              // SIGNATURE CANVAS
              // ==============================================

              Positioned.fill(
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _isSigned = true;

                      _signaturePoints.add(
                        details.localPosition,
                      );
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _signaturePoints.add(
                        details.localPosition,
                      );
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _signaturePoints.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: SignaturePainter(
                      points: _signaturePoints,
                    ),
                  ),
                ),
              ),

              // ==============================================
              // DATE / TIME
              // ==============================================

              Positioned(
                right: 10,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "23 Sep 2026 13:27",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Date / दिनांक",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // ==============================================
              // SIGN HERE TEXT
              // ==============================================

              if (!_isSigned)
                Positioned(
                  left: 15,
                  bottom: 10,
                  child: Text(
                    "Sign here / यहाँ हस्ताक्षर करें",
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 5),

        // ----------------------------------------------------------
        // SIGNATURE LABEL
        // ----------------------------------------------------------

        if (_isSigned)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  // Signature clear
                  _signaturePoints.clear();

                  // Saved signature bhi clear
                  var savedSignature = null;

                  // Sign status reset
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
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          if (!_isSigned || savedSignature == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Please complete your signature first",
                ),
              ),
            );

            return;
          }

          // Generate + Print / Save PDF
          await _printConsent();

          if (!mounted) return;

          // Next page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DutySummaryScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          "SUBMIT & CONSENT",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
