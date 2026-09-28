import 'package:flutter/material.dart';
import 'package:mysis/KoshLoan/KoshBottomSheet.dart';
import 'package:mysis/KoshLoan/demo%20api/ConvertedApi.dart';
import 'package:mysis/KoshLoan/demo%20api/Converted_model/ConvertedleadModel.dart';
import 'package:mysis/KoshLoan/walletapi.dart';
import 'package:mysis/KoshLoan/walletmodel.dart';
import 'package:mysis/constants/app_colors.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final TextEditingController mobileController = TextEditingController();

  int selectedTab = 0;

  walletmodel? wallet;
  bool isWalletLoading = true;
  String? walletError;

  ConvertedLeadModel? convertedLead;
  bool isConvertedLoading = true;
  String? convertedError;

  @override
  @override
  void initState() {
    super.initState();
    loadWallet();
    loadConvertedLeads();
  }

  Future<void> loadConvertedLeads() async {
    try {
      final data = await ConvertedApi().getConvertedLeadModel();

      if (!mounted) return;

      setState(() {
        convertedLead = data;
        isConvertedLoading = false;
        convertedError = null;
      });
    } catch (e) {
      print("Converted Leads API Error: $e");

      if (!mounted) return;

      setState(() {
        isConvertedLoading = false;
        convertedError = e.toString();
      });
    }
  }

  Future<void> loadWallet() async {
    try {
      final data = await WalletApi.getWallet();

      if (!mounted) return;

      setState(() {
        wallet = data;
        isWalletLoading = false;
      });
    } catch (e) {
      print("Wallet API Error: $e");

      if (!mounted) return;

      setState(() {
        isWalletLoading = false;
        walletError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  bool get isMobileValid {
    return mobileController.text.length == 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                // ================= TOP LOGOS =================
                SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // LEFT LOGO
                      Image.asset(
                        "assets/images/icons/SIS-logo.png",
                        width: 125,
                        height: 55,
                        fit: BoxFit.contain,
                      ),

                      // RIGHT LOGO
                      Image.asset(
                        "assets/images/icons/icon.png",
                        width: 90,
                        height: 55,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),

                // ================= TOP HEADER =================
                SizedBox(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.only(right: 35),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            fontWeight: FontWeight.w900,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const Text(
                        "Refer And Earn",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= SUB TITLE =================
                const Text(
                  "Refer friends. Earn rewards. Redeem anytime",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 28),

                // ================= LABEL =================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      "Please provide the mobile number you'd like to refer",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 9),

// ================= REFER BUTTON =================
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      isDense: true,

                      // Text ko properly center rakhega
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      hintText: "Enter Your Phone Number",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 9),

// ================= REFER BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isMobileValid
                        ? () {
                            print(
                              "Refer: ${mobileController.text}",
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.red,
                      disabledBackgroundColor: AppColors.blueGrey50,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      "Refer",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 17),

                // ================= SEE HOW IT WORKS =================
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KoshBottomSheet(),
                        ));
                  },
                  child: const Text(
                    "See how it works",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ================= TABS =================
                Row(
                  children: [
                    _buildTab(
                      title: "Wallet",
                      index: 0,
                    ),
                    const SizedBox(width: 10),
                    _buildTab(
                      title: "Converted Leads",
                      index: 1,
                    ),
                    const SizedBox(
                      width: 9,
                      height: 9,
                    ),
                    _buildTab(
                      title: "Leads",
                      index: 2,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                if (selectedTab == 0) _walletContent(),

                if (selectedTab == 1) _convertedLeadsContent(),

                if (selectedTab == 2) _leadsContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TAB
  Widget _buildTab({
    required String title,
    required int index,
  }) {
    final bool selected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.red : AppColors.blueGrey50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // WALLET
  // ============================================================

  // Widget _walletContent() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //   child:  Column(
  //     children: [
  //       const Text(
  //         "Wallet Balance",
  //         style: TextStyle(
  //           fontFamily: 'Inter',
  //           fontSize: 20,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //
  //       const SizedBox(height: 5),
  //
  //       const Text(
  //         "₹0",
  //         style: TextStyle(
  //           fontFamily: 'Inter',
  //           fontSize: 25,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.red,
  //         ),
  //       ),
  //
  //       const SizedBox(height: 27),
  //
  //       _walletRow(
  //         "Total Earned",
  //         "₹0",
  //       ),
  //
  //       const SizedBox(height: 9),
  //
  //       _walletRow(
  //         "Total withdrawn",
  //         "₹0",
  //       ),
  //
  //       const SizedBox(height: 9),
  //
  //       _walletRow(
  //         "Withdrawal in process",
  //         "₹0",
  //       ),
  //
  //       const SizedBox(height: 9),
  //
  //       _walletRow(
  //         "Withdrawal limit",
  //         "₹0",
  //       ),
  //
  //       const SizedBox(height: 9),
  //
  //       _walletRow(
  //         "Weekly Approved",
  //         "₹0",
  //       ),
  //
  //       const SizedBox(height: 30),
  //
  //       // ================= REDEEM BUTTON =================
  //       SizedBox(
  //         height: 55,
  //         child: ElevatedButton(
  //           onPressed: () {
  //             // Redeem API
  //           },
  //           style: ElevatedButton.styleFrom(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 30,
  //             ),
  //             elevation: 1,
  //             backgroundColor: Colors.red,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           child: const Text(
  //             "Redeem Now",
  //             style: TextStyle(
  //
  //               fontFamily: 'Inter',
  //               color: Colors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  //   );
  // }

  // ============================================================
  // WALLET ROW
  // ============================================================

  Widget _walletContent() {
    if (isWalletLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (walletError != null) {
      return Center(
        child: Column(
          children: [
            const Text(
              "Failed to load wallet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isWalletLoading = true;
                  walletError = null;
                });

                loadWallet();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (wallet == null) {
      return const Center(
        child: Text("No wallet data found"),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            "Wallet Balance",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "₹${wallet!.totalEarned}",
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 27),
          _walletRow(
            "Total Earned",
            "₹${wallet!.totalEarned}",
          ),
          const SizedBox(height: 9),
          _walletRow(
            "Total withdrawn",
            "₹${wallet!.totalWithdrawn}",
          ),
          const SizedBox(height: 9),
          _walletRow(
            "Withdrawal in process",
            "₹${wallet!.withdrawalInProcess}",
          ),
          const SizedBox(height: 9),
          _walletRow(
            "Withdrawal limit",
            "₹${wallet!.withdrawalLimit}",
          ),
          const SizedBox(height: 9),
          _walletRow(
            "Weekly Approved",
            "₹0",
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // Redeem API
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                elevation: 1,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Redeem Now",
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletRow(
    String title,
    String amount,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16, // 👈 TEXT SIZE INCREASED
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _convertedLeadsContent() {
    if (isConvertedLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );
    }

    if (convertedError != null) {
      return Center(
        child: Column(
          children: [
            const Text(
              "Failed to load converted leads",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isConvertedLoading = true;
                  convertedError = null;
                });

                loadConvertedLeads();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (convertedLead == null) {
      return const Center(
        child: Text("No converted leads found"),
      );
    }

    final loans = convertedLead!.loans;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// ================= LOAN SUMMARY =================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              _loanSummaryRow(
                "Your Loans",
                "${convertedLead!.yourLoans}",
              ),
              const SizedBox(height: 8),
              _loanSummaryRow(
                "Amount disbursed",
                "₹${convertedLead!.amountDisbursed}",
              ),
            ],
          ),
        ),

        const SizedBox(height: 17),

// ================= FILTER =================

        GestureDetector(
          onTap: () {
// Filter action
          },
          child: Row(
            children: const [
              Icon(
                Icons.tune,
                size: 18,
                color: Colors.grey,
              ),
              SizedBox(width: 7),
              Text(
                "Select Filter",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

// ================= EMPTY STATE =================

        if (loans.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "No converted loans found",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

// ================= LOAN LIST =================

        ...loans.map(
          (loan) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _loanCard(
              loanId: loan.loanId,
              status: loan.loanStatusText.isNotEmpty
                  ? loan.loanStatusText
                  : loan.loanStatus,
              amount: "₹${loan.loanAmount}",
              comment: loan.comment,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _loanSummaryRow(
  String title,
  String amount,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      Text(
        amount,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Widget _loanCard({
  required String loanId,
  required String status,
  required String amount,
  required String comment,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 11,
    ),
    decoration: BoxDecoration(
      color: AppColors.blueGrey50,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "Loan ID:$loanId",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                "Loan Status: $status",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          "Loan Amount: $amount",
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Comment: $comment",
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

// ============================================================
// LEADS
// ============================================================
Widget _leadsContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ================= FILTER + SEARCH =================
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Icon(
                  Icons.tune,
                  size: 18,
                  color: Colors.grey,
                ),
                SizedBox(width: 7),
                Text(
                  "Select by date",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Search action
            },
            child: const Icon(
              Icons.search,
              size: 22,
              color: Colors.black54,
            ),
          ),
        ],
      ),

      const SizedBox(height: 14),

      // ================= LEADS LIST =================

      _leadRow(
        mobile: "9959874612",
        date: "Created on 12-08-2024",
      ),

      _leadRow(
        mobile: "9959874612",
        date: "Created on 12-08-2024",
      ),

      _leadRow(
        mobile: "9959874612",
        date: "Created on 12-08-2024",
      ),

      _leadRow(
        mobile: "9959874612",
        date: "Created on 12-08-2024",
      ),

      _leadRow(
        mobile: "9959874612",
        date: "Created on 12-08-2024",
      ),

      _leadRow(
        mobile: "9959874612",
        date: "Created on 12-08-2024",
      ),
    ],
  );
}

Widget _leadRow({
  required String mobile,
  required String date,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      vertical: 16,
    ),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey75,
          // color: Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
    ),
    child: Row(
      children: [
//Mobile =================
        Expanded(
          flex: 4,
          child: Text(
            mobile,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        //DATE
        Expanded(
          flex: 5,
          child: Text(
            date,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),

        GestureDetector(
          onTap: () {},
          child: Image.asset(
            'assets/images/KoshImage/whatsapp_icon.png',
            width: 19,
            height: 19,
          ),
        ),
      ],
    ),
  );
}
