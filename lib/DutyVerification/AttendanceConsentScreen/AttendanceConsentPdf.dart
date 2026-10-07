import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AttendanceConsentPdf {
  // ============================================================
  // CREATE PDF
  // ============================================================

  static Future<Uint8List> generatePdf({
    required String employeeName,
    required String registrationNo,
    required String period,

    // Signature points coming from SignatureScreen
    List<ui.Offset?>? signaturePoints,
  }) async {
    final pdf = pw.Document();




    // ============================================================
    // SIS LOGO
    // ============================================================

    pw.MemoryImage? sisLogo;
    pw.MemoryImage? sisIcon;

    try {
      final logoData = await rootBundle.load(
        "assets/images/SIS-logo.png",
      );

      sisLogo = pw.MemoryImage(
        logoData.buffer.asUint8List(),
      );
    } catch (_) {}

    try {
      final iconData = await rootBundle.load(
        "assets/images/icon.png",
      );

      sisIcon = pw.MemoryImage(
        iconData.buffer.asUint8List(),
      );
    } catch (_) {}

    // ============================================================
    // HINDI FONT
    // ============================================================

    final hindiFont =
    await PdfGoogleFonts.notoSansDevanagariRegular();

    final hindiBoldFont =
    await PdfGoogleFonts.notoSansDevanagariBold();

    // ============================================================
    // PAGE
    // ============================================================

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 25,
        ),

        theme: pw.ThemeData.withFont(
          base: hindiFont,
          bold: hindiBoldFont,
        ),

        build: (context) {
          return [

            // ==================================================
            // HEADER
            // ==================================================

            pw.Column(
              children: [

                pw.SizedBox(
                  height: 65,

                  child: pw.Row(
                    mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,

                    children: [

                      if (sisLogo != null)
                        pw.SizedBox(
                          width: 250,
                          height: 60,
                          child: pw.Image(
                            sisLogo,
                            fit: pw.BoxFit.contain,
                            alignment:
                            pw.Alignment.centerLeft,
                          ),
                        ),

                      if (sisIcon != null)
                        pw.SizedBox(
                          width: 55,
                          height: 55,
                          child: pw.Image(
                            sisIcon,
                            fit: pw.BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                ),

                pw.Container(
                  height: 2,
                  width: double.infinity,
                  color: PdfColors.red800,
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // ==================================================
            // DATE
            // ==================================================

            pw.Align(
              alignment: pw.Alignment.centerRight,

              child: pw.Text(
                "Date / दिनांक : 23 Sep 2026",
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 12),

            // ==================================================
            // TITLE
            // ==================================================

            pw.Container(
              width: double.infinity,

              padding: const pw.EdgeInsets.symmetric(
                vertical: 7,
              ),

              color: PdfColors.grey100,

              child: pw.Column(
                children: [

                  pw.Text(
                    "Attendance Verification & Consent",
                    textAlign: pw.TextAlign.center,

                    style: pw.TextStyle(
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red800,
                    ),
                  ),

                  pw.SizedBox(height: 3),

                  pw.Text(
                    "उपस्थिति सत्यापन एवं सहमति पत्र",
                    textAlign: pw.TextAlign.center,

                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 12),

            // ==================================================
            // INTRODUCTION
            // ==================================================

            pw.Text(
              "I, the undersigned, hereby confirm and declare the "
                  "following regarding my attendance for the period "
                  "mentioned below.",

              style: const pw.TextStyle(
                fontSize: 10.5,
                lineSpacing: 2,
              ),
            ),

            pw.SizedBox(height: 5),

            pw.Text(
              "मैं, अधोहस्ताक्षरी, निम्नलिखित के संबंध में पुष्टि और घोषणा "
                  "करता/करती हूँ कि मेरे द्वारा नीचे उल्लिखित अवधि की उपस्थिति "
                  "के संबंध में निम्नलिखित कथन सत्य और सही हैं।",

              style: const pw.TextStyle(
                fontSize: 10,
                lineSpacing: 2,
              ),
            ),

            pw.SizedBox(height: 12),

            // ==================================================
            // EMPLOYEE TABLE
            // ==================================================

            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey800,
                width: 0.6,
              ),

              columnWidths: {
                0: const pw.FlexColumnWidth(1.1),
                1: const pw.FlexColumnWidth(1.5),
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
            ),

            pw.SizedBox(height: 12),

            // ==================================================
            // POINT 1
            // ==================================================

            _consentRow(
              "1",
              "I verify that my attendance for the period "
                  "mentioned above is fully correct and accurate.",

              "मैं पुष्टि करता/करती हूँ कि उपर्युक्त अवधि की "
                  "मेरी उपस्थिति पूर्णतः सही और सटीक है।",
            ),

            _line(),

            // ==================================================
            // POINT 2
            // ==================================================

            _consentRow(
              "2",
              "Other than the claim of attendance submitted by me, "
                  "the acceptance of which is pending at the level of "
                  "the appropriate authority, no other missing attendance "
                  "claim or any other claim related to attendance is pending.",

              "मेरे द्वारा प्रस्तुत उपस्थिति दावे के अलावा, जिसकी स्वीकृति "
                  "संबंधित प्राधिकारी स्तर पर लंबित है, कोई अन्य अनुपस्थित "
                  "उपस्थिति दावा या उपस्थिति से संबंधित कोई अन्य दावा लंबित नहीं है।",
            ),

            _line(),

            // ==================================================
            // POINT 3
            // ==================================================

            _consentRow(
              "3",
              "I further agree that on the basis of the said "
                  "attendance, the process of my salary generation "
                  "should be proceeded.",

              "मैं यह भी सहमत हूँ कि उपयुक्त उपस्थिति के आधार "
                  "पर मेरे वेतन निर्माण की प्रक्रिया आगे बढ़ाई जाए।",
            ),

            _line(),

            // ==================================================
            // POINT 4
            // ==================================================

            _consentRow(
              "4",
                "I understand that in case any information provided "
                    "by me is found to be incorrect, I shall be liable "
                    "for appropriate action as per company policy.",

              "मैं समझता/समझती हूँ कि यदि मेरे द्वारा प्रदान की गई "
                  "कोई भी जानकारी गलत पाई जाती है, तो मुझे कंपनी की "
                  "नीति के अनुसार उचित कार्रवाई के लिए उत्तरदायी माना जाएगा।",
            ),

            pw.SizedBox(height: 8),

            // ==================================================
            // DECLARATION
            // ==================================================

            pw.Row(
              crossAxisAlignment:
              pw.CrossAxisAlignment.start,

              children: [

                pw.Container(
                  width: 16,
                  height: 16,

                  color: PdfColors.red800,

                  child: pw.Center(
                    child: pw.Text(
                      "✓",
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),

                pw.SizedBox(width: 7),

                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment:
                    pw.CrossAxisAlignment.start,

                    children: [

                      pw.Text(
                        "I, therefore, declare that the above statements "
                            "are true and correct to the best of my knowledge "
                            "and belief.",

                        style: const pw.TextStyle(
                          fontSize: 9.5,
                          lineSpacing: 1.5,
                        ),
                      ),

                      pw.SizedBox(height: 4),

                      pw.Text(
                        "अतः, मैं घोषणा करता/करती हूँ कि उपयुक्त कथन मेरे "
                            "ज्ञान और विश्वास के अनुसार सत्य और सही हैं।",

                        style: const pw.TextStyle(
                          fontSize: 9.5,
                          lineSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // ==================================================
            // SIGNATURE
            // ==================================================

            _signatureSection(
              signaturePoints,
            ),

            pw.SizedBox(height: 18),

            // ==================================================
            // SUBMIT TEXT
            // ==================================================

            pw.Center(
              child: pw.Container(
                width: 190,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 10,
                ),

                decoration: pw.BoxDecoration(
                  color: PdfColors.red800,

                  borderRadius:
                  pw.BorderRadius.circular(25),
                ),

                child: pw.Center(
                  child: pw.Text(
                    "SUBMIT & CONSENT",

                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // TABLE ROW
  // ============================================================

  static pw.TableRow _tableRow(
      String title,
      String value,
      ) {
    return pw.TableRow(
      children: [

        pw.Padding(
          padding: const pw.EdgeInsets.all(7),

          child: pw.Text(
            title,

            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),
        ),

        pw.Padding(
          padding: const pw.EdgeInsets.all(7),

          child: pw.Text(
            value,

            style: pw.TextStyle(
              fontSize: 11,
              fontWeight:
              pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONSENT ROW
  // ============================================================

  static pw.Widget _consentRow(
      String number,
      String english,
      String hindi,
      ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        vertical: 7,
      ),

      child: pw.Row(
        crossAxisAlignment:
        pw.CrossAxisAlignment.start,

        children: [

          pw.Container(
            width: 18,
            height: 18,

            decoration: pw.BoxDecoration(
              color: PdfColors.red800,
              borderRadius:
              pw.BorderRadius.circular(4),
            ),

            child: pw.Center(
              child: pw.Text(
                number,

                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ),

          pw.SizedBox(width: 5),

          pw.Expanded(
            child: pw.Text(
              english,

              style: const pw.TextStyle(
                fontSize: 8.8,
                lineSpacing: 1.4,
              ),
            ),
          ),

          pw.Container(
            width: 0.5,
            height: 65,
            color: PdfColors.grey400,

            margin:
            const pw.EdgeInsets.symmetric(
              horizontal: 6,
            ),
          ),

          pw.Expanded(
            child: pw.Text(
              hindi,

              style: const pw.TextStyle(
                fontSize: 8.8,
                lineSpacing: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  static pw.Widget _line() {
    return pw.Container(
      height: 0.5,
      width: double.infinity,
      color: PdfColors.grey300,
    );
  }

  // ============================================================
  // SIGNATURE
  // ============================================================

  static pw.Widget _signatureSection(
      List<ui.Offset?>? points,
      ) {
    return pw.Column(
      crossAxisAlignment:
      pw.CrossAxisAlignment.start,

      children: [

        pw.Container(
          height: 85,
          width: double.infinity,

          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.grey500,
              width: 0.6,
            ),

            borderRadius:
            pw.BorderRadius.circular(5),
          ),

          child: pw.Stack(
            children: [

              if (points != null &&
                  points.isNotEmpty)
                pw.Positioned(
                  left: 10,
                  top: 5,

                  child: pw.CustomPaint(
                    size: const PdfPoint(
                      300,
                      65,
                    ),

                    painter: (
                        PdfGraphics canvas,
                        PdfPoint size,
                        ) {

                      final paint =
                      PdfColor.fromInt(
                        0xFF000000,
                      );

                      canvas.setStrokeColor(
                        paint,
                      );

                      canvas.setLineWidth(
                        1.4,
                      );

                      for (
                      int i = 0;
                      i < points.length - 1;
                      i++
                      ) {

                        final current =
                        points[i];

                        final next =
                        points[i + 1];

                        if (current == null ||
                            next == null) {
                          continue;
                        }

                        final x1 =
                            current.dx / 3;

                        final y1 =
                            current.dy / 3;

                        final x2 =
                            next.dx / 3;

                        final y2 =
                            next.dy / 3;

                        canvas.drawLine(
                          x1,
                          y1,
                          x2,
                          y2,
                        );
                      }
                    },
                  ),
                ),

              pw.Positioned(
                right: 8,
                bottom: 8,

                child: pw.Column(
                  crossAxisAlignment:
                  pw.CrossAxisAlignment.end,

                  children: [

                    pw.Text(
                      "23 Sep 2026 13:27",

                      style:
                      pw.TextStyle(
                        fontSize: 7.5,
                        fontWeight:
                        pw.FontWeight.bold,
                      ),
                    ),

                    pw.Text(
                      "Date / दिनांक",

                      style:
                      const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 4),

        pw.Text(
          "Signature of Employee / कर्मचारी के हस्ताक्षर",

          style: const pw.TextStyle(
            fontSize: 7.5,
          ),
        ),
      ],
    );
  }
}