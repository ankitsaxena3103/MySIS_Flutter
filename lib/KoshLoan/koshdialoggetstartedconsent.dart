import 'package:flutter/material.dart';
import 'package:mysis/KoshLoan/KoshAlternateWhatsappDialog.dart';
import 'package:mysis/KoshLoan/repo/kosh_base_api_client.dart';
import 'package:mysis/SharedClasses/Preferences.dart';
import 'package:mysis/constants/app_colors.dart';

import '../CommonViews/Utility.dart';

class KoshDialogGetStartedConsent extends StatefulWidget {
   KoshDialogGetStartedConsent({super.key});

  @override
  State<KoshDialogGetStartedConsent> createState() =>
      _KoshDialogGetStartedConsentState();
}

class _KoshDialogGetStartedConsentState
    extends State<KoshDialogGetStartedConsent> {
  bool loanConsent = false;
  bool termsConsent = false;
  final koshClient = KoshBaseApiClient();

  @override
  Widget build(BuildContext context) {
    final isValid = loanConsent && termsConsent;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD6D6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism_outlined,
                size: 27,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Get Started with Kosh Loan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'To check your loan eligibility, kosh needs your '
                  'permission to securely fetch the following '
                  'information from your employer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  _infoRow(
                    Icons.phone_outlined,
                    'Mobile Number',
                  ),
                  _infoRow(
                    Icons.chat_outlined,
                    'WhatsApp Number',
                  ),
                  _infoRow(
                    Icons.badge_outlined,
                    'Employment Vintage (joining Duration)',
                  ),
                  _infoRow(
                    Icons.currency_rupee,
                    'Monthly Salary',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _checkBoxRow(
              value: loanConsent,
              text: 'I authorize Kosh to use the above information '
                  'for loan eligibility verification.',
              onChanged: (value) {
                setState(() {
                  loanConsent = value;
                });
              },
            ),

            const SizedBox(height: 5),
            _checkBoxRow(
              value: termsConsent,
              text: 'I agree to the Terms & Conditions and Privacy Policy.',
              onChanged: (value) {
                setState(() {
                  termsConsent = value;
                });
              },
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black.withOpacity(0.50),
                    builder: (context) {
                      return KoshAlternateWhatsappDialog();
                    },
                  );

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //     const KoshAlternateWhatsappDialog(),
                  //   ),
                  // );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: AppColors.blueGrey50,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Yes, I'm Interested",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(
                    color: Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Not Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.red,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkBoxRow({
    required bool value,
    required String text,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: (value) {
              onChanged(value ?? false);
            },
            activeColor: Colors.red,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _createToken();
  }
  Future<void> _createToken() async {
    print("API Called");
    String? kosh_Token= await Preferences.getUserPreference(KOSH_TOKEN);
    print("API Called..kosh_Token$kosh_Token");

    await koshClient.createToken(
      KOSH_USERNAME,
      KOSH_PASSWORD,
      onSuccess: (response) {
        print('Logged in. Access token: ${koshClient.accessToken}');
      },
      onError: (message, statusCode) {
        print('Login failed ($statusCode): $message');
      },
    );
  }
}

