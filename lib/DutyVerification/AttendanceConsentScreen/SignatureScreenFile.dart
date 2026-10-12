
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'SignaturePainter.dart';

class SignatureScreenFile extends StatefulWidget {
  const SignatureScreenFile({super.key});

  @override
  State<SignatureScreenFile> createState() =>
      _SignatureScreenFileState();
}

class _SignatureScreenFileState
    extends State<SignatureScreenFile> {
  final GlobalKey _canvasKey = GlobalKey();

  final List<Offset?> _signaturePoints = [];

  bool _isSigned = false;
  bool _isSaving = false;

  static const Color primaryRed = Color(0xFFB51D1D);
  static const Color buttonRed = Color(0xFFC43136);
  static const Color canvasColor = Color(0xFFFAF8F0);
  static const Color borderColor = Color(0xFF34342C);
  static const Color hintColor = Color(0xFFAAA795);

  void _clearSignature() {
    setState(() {
      _signaturePoints.clear();
      _isSigned = false;
    });
  }

  Future<File?> _exportSignature() async {
    final renderObject =
    _canvasKey.currentContext?.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      return null;
    }

    final ui.Image image = await renderObject.toImage(
      pixelRatio: 3.0,
    );

    try {
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) return null;

      final directory =
      await getApplicationDocumentsDirectory();

      final file = File(
        '${directory.path}/signature_'
            '${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(
        byteData.buffer.asUint8List(),
        flush: true,
      );

      return file;
    } finally {
      image.dispose();
    }
  }

  Future<void> _saveSignature() async {
    if (!_isSigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया पहले हस्ताक्षर करें'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final file = await _exportSignature();

      if (!mounted) return;

      if (file == null) {
        throw Exception('Signature image could not be created');
      }

      Navigator.pop(context, file);
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('हस्ताक्षर सेव नहीं हुए: $error'),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: primaryRed,
      padding: const EdgeInsets.fromLTRB(28, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 25,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'रद्द करें',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'अपने हस्ताक्षर करें',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'नीचे दिए गए बॉक्स में अपनी उंगली से हस्ताक्षर करें',
            style: TextStyle(
              color: Color(0xFFE7C7C7),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureCanvas() {
    final now = DateTime.now();

    final dateText =
        '${now.day.toString().padLeft(2, '0')} '
        '${_monthName(now.month)} ${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.fromLTRB(26, 26, 26, 40),
      decoration: BoxDecoration(
        color: canvasColor,
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: RepaintBoundary(
        key: _canvasKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(color: canvasColor),

                // Finger se signature draw karein.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
                  onPanEnd: (_) {
                    setState(() {
                      _signaturePoints.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: SignaturePainter(
                      points: _signaturePoints,
                    ),
                    size: Size.infinite,
                  ),
                ),

                // Signature box ki bottom line.
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: 46,
                  child: Container(
                    height: 1.5,
                    color: const Color(0xFFD4D1BD),
                  ),
                ),

                // Signature karne ka hint.
                if (!_isSigned)
                  const Positioned(
                    left: 22,
                    top: 24,
                    child: IgnorePointer(
                      child: Text(
                        'लाइन के ऊपर हस्ताक्षर करें',
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                // Date and time bottom-right.
                Positioned(
                  right: 30,
                  bottom: 12,
                  child: IgnorePointer(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Text(
                          dateText,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF777568),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'दिनांक',
                          style: TextStyle(
                            fontSize: 9,
                            color: Color(0xFF777568),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return months[month - 1];
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 12, 40, 16),
      child: Row(
        children: [
          Expanded(
            child: _SignatureButton(
              title: 'साफ़ करें',
              onPressed: _isSaving ? null : _clearSignature,
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            flex: 1,
            child: _SignatureButton(
              title: _isSaving
                  ? 'सेव हो रहा है...'
                  : 'हस्ताक्षर सेव करें',
              onPressed: _isSaving ? null : _saveSignature,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: _buildSignatureCanvas(),
            ),

            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _SignatureButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const _SignatureButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC43136),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0x99C43136),
          elevation: 3,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: const StadiumBorder(),
        ),

        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}