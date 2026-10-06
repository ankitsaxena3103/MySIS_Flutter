/*
 * Created by Ankit Saxena on 05-10-2026.
 */



import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/app_colors.dart';
import 'SignaturePainter.dart';
// import your AppColors here

class SignatureScreenFile extends StatefulWidget {
  const SignatureScreenFile({super.key});

  @override
  State<SignatureScreenFile> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreenFile> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<Offset?> _signaturePoints = [];
  bool _isSigned = false;
  bool _isSaving = false;

  void _clear() {
    setState(() {
      _signaturePoints.clear();
      _isSigned = false;
    });
  }

  Future<File?> _exportSignature() async {
    final boundary = _canvasKey.currentContext!.findRenderObject()
    as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    // unique name so Image.file doesn't show a cached old image
    final file = File(
      '${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    return file;
  }

  Future<void> _onDone() async {
    if (!_isSigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign first / कृपया पहले हस्ताक्षर करें')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final file = await _exportSignature();
      if (!mounted) return;
      Navigator.pop(context, file); // send file back to previous screen
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save signature: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature'),
        actions: [
          TextButton(onPressed: _clear, child: const Text('Clear')),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      // ===== SIGNATURE CANVAS (only this part is exported) =====
                      Positioned.fill(
                        child: RepaintBoundary(
                          key: _canvasKey,
                          child: GestureDetector(
                            onPanStart: (d) => setState(() {
                              _isSigned = true;
                              _signaturePoints.add(d.localPosition);
                            }),
                            onPanUpdate: (d) => setState(() {
                              _signaturePoints.add(d.localPosition);
                            }),
                            onPanEnd: (_) => setState(() {
                              _signaturePoints.add(null);
                            }),
                            child: CustomPaint(
                              painter: SignaturePainter(points: _signaturePoints),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                      ),

                      // ===== DATE / TIME =====
                      Positioned(
                        right: 10,
                        bottom: 12,
                        child: IgnorePointer(
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
                      ),

                      // ===== SIGN HERE TEXT =====
                      if (!_isSigned)
                        Positioned(
                          left: 15,
                          bottom: 10,
                          child: IgnorePointer(
                            child: Text(
                              "Sign here / यहाँ हस्ताक्षर करें",
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== DONE BUTTON =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _onDone,
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Done / हो गया'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}