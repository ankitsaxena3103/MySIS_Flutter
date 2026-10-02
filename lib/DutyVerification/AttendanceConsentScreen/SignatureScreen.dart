import 'package:flutter/material.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() =>
      _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {

  final List<Offset?> _points = [];

  bool get hasSignature => _points.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.red,
            size: 19,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Signature",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [

          TextButton(
            onPressed: () {

              setState(() {
                _points.clear();
              });

            },

            child: const Text(
              "CLEAR",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          const Text(
            "Please sign below",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "कृपया नीचे हस्ताक्षर करें",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // SIGNATURE BOX
          // =====================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,

                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),

                  borderRadius:
                  BorderRadius.circular(8),
                ),

                child: GestureDetector(

                  onPanStart: (details) {

                    setState(() {

                      _points.add(
                        details.localPosition,
                      );

                    });

                  },

                  onPanUpdate: (details) {

                    setState(() {

                      _points.add(
                        details.localPosition,
                      );

                    });

                  },

                  onPanEnd: (details) {

                    setState(() {

                      _points.add(null);

                    });

                  },

                  child: CustomPaint(
                    painter: SignaturePainter(
                      points: _points,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // =====================================================
          // DONE BUTTON
          // =====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              25,
            ),

            child: SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: hasSignature
                    ? () {

                  Navigator.pop(
                    context,
                    _points,
                  );

                }
                    : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,

                  disabledBackgroundColor:
                  Colors.grey.shade300,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(25),
                  ),
                ),

                child: const Text(
                  "DONE",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// =============================================================
// SIGNATURE PAINTER
// =============================================================

class SignaturePainter extends CustomPainter {

  final List<Offset?> points;

  SignaturePainter({
    required this.points,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (
    int i = 0;
    i < points.length - 1;
    i++
    ) {

      final current = points[i];
      final next = points[i + 1];

      if (current == null ||
          next == null) {
        continue;
      }

      canvas.drawLine(
        current,
        next,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant SignaturePainter oldDelegate,
      ) {

    return oldDelegate.points != points;
  }
}