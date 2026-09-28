import 'package:flutter/material.dart';
import 'package:mysis/KoshLoan/ReferAndEarnScreen.dart';
import 'package:mysis/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class KoshSuccessScreen extends StatelessWidget {
  const KoshSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.10),
                SizedBox(
                  height: 145,
                  width: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pink background circle
                      Positioned(
                        bottom: 10,
                        child: Container(
                          width: 115,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.pink50,
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                      ),

                      Container(
                        width: 80,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Container(
                              width: 25,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 22,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),

                      Positioned(
                        right: 20,
                        top: 18,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),

                      const Positioned(
                        left: 8,
                        top: 25,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.green,
                          size: 13,
                        ),
                      ),

                      const Positioned(
                        right: 3,
                        top: 52,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.lightGreenAccent,
                          size: 18,
                        ),
                      ),

                      const Positioned(
                        left: 4,
                        bottom: 35,
                        child: Icon(
                          Icons.circle_outlined,
                          color: Colors.lightGreenAccent,
                          size: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: "Interest Submitted ",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      TextSpan(
                        text: "Successfully!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Kosh has received your interest.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.white,
                ),
                const SizedBox(height: 13),
                const Text(
                  "To apply for a loan and continue with the\n"
                  "next steps, download the Kosh App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontFamily: 'Inter', color: Colors.grey),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      openAppOrPlayStore();
                      // const packageName = 'com.kosh';
                      //
                      // final koshUrl = Uri.parse('kosh://');
                      // final playStoreUrl = Uri.parse(
                      //   'https://play.google.com/store/apps/details?id=$packageName',
                      // );
                      //
                      // if (await canLaunchUrl(koshUrl)) {
                      //   await launchUrl(
                      //     koshUrl,
                      //     mode: LaunchMode.externalApplication,
                      //   );
                      // } else {
                      //   await launchUrl(
                      //     playStoreUrl,
                      //     mode: LaunchMode.externalApplication,
                      //   );
                      // }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 20,
                        ),

                        SizedBox(width: 6),

                        Text(
                          "Download Kosh App",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const ReferAndEarnScreen(),
                    //     ));
                  },
                  child: const Text(
                    "Maybe Later",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Help Icon
                      Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.hintText,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.headset_mic_outlined,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 20),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Need help or have questions?",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Our Kosh support team is here to help you.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  "Kosh Helpline  |  +918595623585",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openAppOrPlayStore() async {
    const packageName = 'com.kosh';

    final playStoreUri = Uri.parse(
      'market://details?id=$packageName',
    );

    final webUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    // Try to open the app
    final appUri = Uri.parse(
      'intent://$packageName#Intent;scheme=$packageName;package=$packageName;end',
    );

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri);
      } else if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri);
      } else {
        await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
