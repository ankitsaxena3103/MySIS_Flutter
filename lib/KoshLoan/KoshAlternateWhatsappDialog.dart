import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysis/KoshLoan/KoshSuccessScreen.dart';
import 'package:mysis/constants/app_colors.dart';

class KoshAlternateWhatsappDialog extends StatefulWidget {
  const KoshAlternateWhatsappDialog({super.key});

  @override
  State<KoshAlternateWhatsappDialog> createState() =>
      _AlternateWhatsappDialogState();
}


class _AlternateWhatsappDialogState extends State<KoshAlternateWhatsappDialog> {
  final TextEditingController phoneController = TextEditingController();

  bool isChecked = false;

  bool get isValid {
    return phoneController.text.length == 10 && isChecked;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void continuePressed() {
    if (!isValid) return;

    String phoneNumber = phoneController.text;

    Navigator.pop(context, phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 36, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // WhatsApp Icon
            Container(
              height: 58,
              width: 58,
              decoration:  BoxDecoration(
                  color: AppColors.pink75,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/images/KoshImage/whatsapp.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Add an Alternate WhatsApp Number (Optional)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            Container(
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Text(
                    "+91",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,

                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 12),
                  Container(
                    height: 28,
                    width: 1,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "Enter 10 digit number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: isChecked,
                    activeColor: Colors.red,
                    checkColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },

                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "This number belongs to me or I have permission to "
                    "receive loan-related communication on it",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isValid ? continuePressed : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            isValid ? Colors.red : AppColors.blueGrey50,
                        disabledBackgroundColor: AppColors.blueGrey75,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KoshSuccessScreen(),
                            ));
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
