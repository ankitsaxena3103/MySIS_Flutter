import 'package:flutter/material.dart';

class KoshBottomSheet extends StatelessWidget {
  const KoshBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 500,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "How Refer and Earn works",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 38),
                _infoItem(
                  image: "assets/images/KoshImage/Phone_icon.png",
                  title: "Refer a Friend",
                  description: "Enter the mobile number of the person you want "
                      "to refer. Once submitted, a lead is created "
                      "instantly.",
                ),
                const SizedBox(height: 22),
                _infoItem(
                  image: "assets/images/KoshImage/Refer_icon.png",
                  title: "Become Group Leader",
                  description:
                      "When your referred person applies for a Group Loan from Kosh, "
                      "you automatically become the Group Leader of that group.",
                ),
                const SizedBox(height: 22),
                _infoItem(
                  image: "assets/images/KoshImage/wallet_icon.png",
                  title: "Earn Your Reward",
                  description: "Once the loan is approved and disbursed, "
                      "and the referred person successfully completes "
                      "the first EMI, your reward is credited to your wallet.",
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Call functionality
                  },
                  child: const Text(
                    "Need Assistance? Call Us",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoItem({
    required String image,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            image,
            width: 36,
            height: 36,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'inter',
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: 0,
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}
