import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysis/KoshLoan/KoshBottomSheet.dart';
import 'package:mysis/KoshLoan/repo/kosh_base_api_client.dart';
import 'package:mysis/KoshLoan/walletapi.dart';
import 'package:mysis/KoshLoan/walletmodel.dart';
import 'package:mysis/constants/app_colors.dart';

import '../CommonViews/ToastMessageView.dart';
import '../CommonViews/Utility.dart';
import '../SharedClasses/Preferences.dart';
import 'model/PipelineRecord.dart';
import 'model/WalletResponse.dart';
import 'model/loan_response_parser.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final TextEditingController mobileController = TextEditingController();
  final koshClient = KoshBaseApiClient();
  bool showToastMessageView = false;
  String userToken = '';
  int selectedTab = 0;
  List<PipelineRecord> leadList = [];
  WalletResponse? walletData;


  walletmodel? wallet;
  bool isWalletLoading = true;
  String? walletError;

  // ---- Pagination state ----
  int page = 1;
  bool isConvertLeadLoading = false;
  bool isLastPage = false;

  // ---- Local UI state (replaces contentConvertedLeads visibility + text views) ----
  bool isConvertedContentVisible = false;
  bool isConvertedCall = false;
  double loanAmount = 0;
  double disbursedAmount = 0;
  final List<LoanGroup> loanGroups = [];

  int? _currentStatus;
  bool isProgressVisible = false;
  final _scrollController = ScrollController();
  int _status = 1; // 1 = pre_approval, 2 = post_approval

  /// resetPage: true -> fresh load (tab switch / pull-to-refresh), starts at page 1.
  /// resetPage: false -> fetch the next page and append.

  @override
  void initState() {
    super.initState();
    _createToken();
    _scrollController.addListener(_onScroll);

    // loadWallet();
  }

  void _switchPhase(int status) {
    if (status == _status) return;
    setState(() => _status = status);
    loadPage(status);
  }

  Future<void> _onRefresh() async {
    await loadPage(_status, resetPage: true);
  }

  void _onScroll() {
    if (isConvertLeadLoading || isLastPage) return;
    const threshold = 200.0;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - threshold) {
      loadNextPage();
    }
  }

  Future<void> _createToken() async {
    print("API Called");
    String? kosh_Token = await Preferences.getUserPreference(KOSH_TOKEN);
    print("API Called..kosh_Token$kosh_Token");

    await koshClient.createToken(
      KOSH_USERNAME,
      KOSH_PASSWORD,
      onSuccess: (response) async {
        print('Logged in. Access token: ${koshClient.accessToken}');
        String userLoggedInContactNo =
            await Preferences.getUserPreference(keyMobile) ?? '';
        print(' userLoggedInContactNo ($userLoggedInContactNo)');

        await koshClient.findPersonByUser(
          userLoggedInContactNo,
          onSuccess: (response) async {
            print('findPersonByUser...RESPONSE: ${response}');

            final bool success = response['success'] as bool? ?? false;
            final Map<String, dynamic> data =
                response['data'] as Map<String, dynamic>? ?? {};

            final String username =
                await Preferences.getUserPreference(keyMobile) ?? '';
            String? token = data[username] as String?;
            userToken = (data[username] as String?) ?? '';
            print('findPersonByUser.....userToken$userToken');
            if (userToken == null || userToken!.isEmpty) {
              showInvalidUserDialog11(
                context,
                onContinue: () {},
                onCancel: () {
                  Navigator.of(context)
                      .pop(); // or your "finish activity" equivalent
                },
              );
            } else {
              setState(() {
                userToken = data[username] as String;
                fetchWallet();

                // fetchConvertedLead();
              });
            }
          },
          onError: (message, statusCode) {
            print('Login failed ($statusCode): $message');
          },
        );
      },
      onError: (message, statusCode) {
        print('Login failed ($statusCode): $message');
      },
    );
  }

  void referFriend() async {
    String loggedInUserNumber =
        await Preferences.getUserPreference(keyMobile) ?? '';

    String referContactNumber = mobileController.text;
    if (referContactNumber.length >= 10) {
// 2. Create a CRM record (uses the stored token automatically)
      await koshClient.createReferralRecord(
        KoshBorrower,
        referContactNumber,
        loggedInUserNumber ?? '',
        onSuccess: (response) =>
        {
          print('Record createReferralRecord: $response'),
          setState(() {
            showToastMessageView = true;
          }),
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              showToastMessageView = false;
            });
          })
        },
        onError: (message, statusCode) => print('Error $statusCode: $message'),
      );
    }

    // Navigator.pop(context, phoneNumber);
  }

  void fetchWallet() async {
    await koshClient.fetchWallet(
      userToken,
      onSuccess: (response) {
        print('Record fetchWallet: $response');

        try {
          final wallet = WalletResponse.fromJson(
            Map<String, dynamic>.from(response),
          );

          setState(() {
            walletData = wallet;
            isWalletLoading=false;
          });
        } catch (e) {
          setState(() {
            walletData = null;
            isWalletLoading=false;
          });
          print('Wallet parsing error: $e');
        }
      },
      onError: (message, statusCode) {
        print('Error $statusCode: $message');
      },
    );
  }

  Future<void> loadPage(int status, {bool resetPage = true}) async {
    if (isConvertLeadLoading) return;
    if (!resetPage && isLastPage) return;

    if (resetPage || _currentStatus != status) {
      page = 1;
      isLastPage = false;
      loanGroups.clear();
      loanAmount = 0;
      disbursedAmount = 0;
      _currentStatus = status;
    }

    isConvertLeadLoading = true;
    setState(() => isProgressVisible = page == 1);

    String url =
        '${KoshConstants.koshBaseUrl}/los/${KoshConstants
        .koshEnv}/loan-group/dashboard/sales-person-groups/';
    final phase = status == 1 ? 'pre_approval' : 'post_approval';
    url = Uri.parse(url).replace(queryParameters: {
      'page': '$page',
      'sales_person': userToken,
      'phase': phase,
    }).toString();

    debugPrint('RESPONSE fetchLeadNDConvertedLead..URL... $url');

    await koshClient.fetchConvertedLead(
      url,
      onSuccess: (json) {
        debugPrint('RESPONSE fetchLeadNDConvertedLead..... $json');

        final response = LoanResponseParser.parseLoanResponse(jsonEncode(json));
        debugPrint('Loan LoanResponse ${response?.disbursedAmount}');
        isConvertedCall = true;

        if (response != null) {
          for (final g in response.loanGroups) {
            for (final l in g.loans) {
              debugPrint('Loan $l');
            }
          }
          _appendPage(response);
          displayConvertedData(response);
        } else {
          isLastPage = true;
          setState(() {
            isConvertLeadLoading = false;
            isConvertedCall = true;
            isProgressVisible = false;
            if (page == 1) isConvertedContentVisible = false;
          });
          // handle parse failure (show error, retry, etc.)
        }
      },
      onError: (errorMessage, statusCode) {
        debugPrint(
            'Pagination Page=$page, StatusCode=$statusCode, Error=$errorMessage');
        isLastPage = true;
        setState(() {
          isConvertedCall = true;
          isConvertLeadLoading = false;
          isProgressVisible = false;
        });
      },
    );
  }

  void _appendPage(LoanResponse response) {
    if (page == 1) {
      loanGroups
        ..clear()
        ..addAll(response.loanGroups);
    } else {
      loanGroups.addAll(response.loanGroups);
    }

    isLastPage =
        response.loanGroups.isEmpty || loanGroups.length >= response.count;
    if (!isLastPage) page++;

    isConvertLeadLoading = false;
    isProgressVisible = false;
  }

  /// Direct port of:
  ///   private void displayConvertedData(LoanResponseParser.LoanResponse response)
  /// loanGroups/loanAmount/disbursedAmount here reflect the ACCUMULATED
  /// (paginated) list, not just the latest page's response — mirrors the
  /// Java version's single-shot (non-paginated) behavior when your API
  /// returns everything in one call.
  void displayConvertedData(LoanResponse response) {
    try {
      setState(() {
        if (loanGroups.isEmpty) {
          isConvertedContentVisible = false;
        } else {
          isConvertedContentVisible = true;
          loanAmount = response.loanAmount;
          disbursedAmount = response.disbursedAmount;
          // loanGroups is already populated by _appendPage(); the adapter
          // equivalent (ListView.builder) just reads from it in build().
        }
      });
    } catch (e) {
      debugPrint('displayConvertedData error: $e');
    }
  }

  /// Call this from a ScrollController listener near the bottom of the list.
  void loadNextPage() {
    final status = _currentStatus;
    if (status == null) return;
    loadPage(status, resetPage: false);
  }

  Future<void> showInvalidUserDialog11(BuildContext context, {
    required VoidCallback onContinue, // e.g. () => registerKoshLoan(context)
    required VoidCallback
    onCancel, // e.g. () => Navigator.pop(context) / finish equivalent
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // matches setCancelable(false) initially
      builder: (dialogContext) {
        return PopScope(
          canPop: true,
          // dialog.setCancelable(true) was set later, so back button can dismiss
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Warning icon circle
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE5E8),
                        // light red bg, adjust to your bg_warning_circle
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Color(0xFFFF1F2D),
                        size: 26,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      'kosh_loan_not_eligible'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1F2D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          onContinue();
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'continue_to_kosh_loan'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF111111),
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          onCancel();
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'Cancel_Kosh'.tr(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    koshClient.dispose();
    super.dispose();
  }

  bool get isMobileValid {
    return mobileController.text.length == 10;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                                // fontWeight: FontWeight.w900,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          Text(
                            'refer_and_earn_title'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= SUB TITLE =================
                    Text(
                      'refer_subtitle'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= LABEL =================
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          'refer_hint'.tr(),
                          style: const TextStyle(
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

                          hintText: 'Enter_Your_Phone_Number'.tr(),
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
                          referFriend();
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
                        child: Text(
                          'refer_btn'.tr(),
                          style: const TextStyle(
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
                      child: Text(
                        'see_how_it_works'.tr(),
                        style: const TextStyle(
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
                          title: 'tab_wallet'.tr(),
                          index: 0,
                        ),
                        const SizedBox(width: 10),
                        _buildTab(
                          title: 'tab_converted_leads'.tr(),
                          index: 1,
                        ),
                        const SizedBox(
                          width: 9,
                          height: 9,
                        ),
                        _buildTab(
                          title: 'tab_leads'.tr(),
                          index: 2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    if (selectedTab == 0) buildWalletSection(walletData),
                    // if (selectedTab == 0) _walletContent(),

                    if (selectedTab == 1) _convertedLeadsContentV2(),

                    if (selectedTab == 2) _leadsContent(),
                  ],
                ),
              ),
            ),
          ),
        ),
        ToastMessageView(
          isVisible: showToastMessageView,
          message: 'Successfully_referred'.tr(),
        ),
      ],
    );
  }

  // Widget _buildLeadList() {
  //   if (isWalletLoading) {
  //     return const Center(child: CircularProgressIndicator());
  //   }
  //   if (walletError != null) {
  //     return Center(child: Text('Error: $walletError'));
  //   }
  //   if (leadList.isEmpty) {
  //     return const Center(child: Text('No leads found'));
  //   }
  //
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: leadList.length,
  //     itemBuilder: (context, index) {
  //       final record = leadList[index];
  //       return _leadRow(pipelineRecord: record);
  //       // return _loanCard(pipelineRecord: record);
  //     },
  //   );
  // }

  Widget _buildConvertedLeadList() {
    if (isWalletLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (walletError != null) {
      return Center(child: Text('Error: $walletError'));
    }
    if (leadList.isEmpty) {
      return const Center(child: Text('No leads found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leadList.length,
      itemBuilder: (context, index) {
        final record = leadList[index];
        return _loanCard(pipelineRecord: record);
      },
    );
  }

  Future<void> _loadLeads() async {
    setState(() {
      isWalletLoading = true;
      walletError = null;
    });

    await koshClient.fetchLeadNDConvertedLead(
      null, // pass a non-null value to filter converted leads only
      userToken,
      onSuccess: (firstResponse) => _onLeadsFetched(firstResponse),
      onError: (message, statusCode) {
        debugPrint('fetchLeadNDConvertedLead error $statusCode: $message');
        setState(() {
          isWalletLoading = false;
          walletError = message;
        });
      },
    );
  }

  Future<void> _onLeadsFetched(List<dynamic> firstResponse) async {
    if (firstResponse.isEmpty) {
      setState(() {
        isWalletLoading = false;
        leadList = [];
      });
      return;
    }

    final List<String> userIdList = _extractUserIds(firstResponse);
    debugPrint('extractUserIds.... ${userIdList.length}');

    final Map<String, dynamic> requestBodyObj = {
      'user_ids': userIdList,
    };

    await koshClient.fetchUserMobileNoBaseOnUserID(
      requestBodyObj,
      onSuccess: (mobileResponse) {
        debugPrint(
            'RESPONSE fetchUserMobileNoBaseOnUSerID..... $mobileResponse');
        try {
          final List<PipelineRecord> finalList = PipelineRecord.buildMergedList(
            firstResponse,
            _mapToJsonString(mobileResponse),
          );
          debugPrint(
              'extractUserIds.... PipelineRecord... ${finalList.length}');

          setState(() {
            leadList = finalList;
            isWalletLoading = false;
          });
        } catch (e) {
          setState(() {
            isWalletLoading = false;
            walletError = 'Failed to merge records: $e';
          });
        }
      },
      onError: (message, statusCode) {
        debugPrint('fetchUserMobileNoBaseOnUserID error $statusCode: $message');
        setState(() {
          isWalletLoading = false;
          walletError = message;
        });
      },
    );
  }

  List<String> _extractUserIds(List<dynamic> response) {
    return response
        .map((item) => (item as Map<String, dynamic>)['user_id'] as String?)
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toList();
  }

  String _mapToJsonString(Map<String, dynamic> map) {
    // KoshBaseApiClient already decodes JSON for you; PipelineRecord.buildMergedList
    // expects a raw JSON string (to mirror the original Java signature), so we
    // re-encode it here. See pipeline_record.dart for details.
    return jsonEncode(map);
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

  // Widget _walletContent() {
  //   if (isWalletLoading) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  //
  //   if (walletError != null) {
  //     return Center(
  //       child: Column(
  //         children: [
  //           const Text(
  //             "Failed to load wallet",
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.red,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 isWalletLoading = true;
  //                 walletError = null;
  //               });
  //
  //               loadWallet();
  //             },
  //             child: const Text("Retry"),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   if (wallet == null) {
  //     return const Center(
  //       child: Text("No wallet data found"),
  //     );
  //   }
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Column(
  //       children: [
  //         const Text(
  //           "Wallet Balance",
  //           style: TextStyle(
  //             fontFamily: 'Inter',
  //             fontSize: 20,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         const SizedBox(height: 5),
  //         Text(
  //           "₹${wallet!.totalEarned}",
  //           style: const TextStyle(
  //             fontFamily: 'Inter',
  //             fontSize: 25,
  //             fontWeight: FontWeight.w700,
  //             color: Colors.red,
  //           ),
  //         ),
  //         const SizedBox(height: 27),
  //         _walletRow(
  //           "Total Earned",
  //           "₹${wallet!.totalEarned}",
  //         ),
  //         const SizedBox(height: 9),
  //         _walletRow(
  //           "Total withdrawn",
  //           "₹${wallet!.totalWithdrawn}",
  //         ),
  //         const SizedBox(height: 9),
  //         _walletRow(
  //           "Withdrawal in process",
  //           "₹${wallet!.withdrawalInProcess}",
  //         ),
  //         const SizedBox(height: 9),
  //         _walletRow(
  //           "Withdrawal limit",
  //           "₹${wallet!.withdrawalLimit}",
  //         ),
  //         const SizedBox(height: 9),
  //         _walletRow(
  //           "Weekly Approved",
  //           "₹0",
  //         ),
  //         const SizedBox(height: 30),
  //         SizedBox(
  //           height: 55,
  //           child: ElevatedButton(
  //             onPressed: () {
  //               // Redeem API
  //             },
  //             style: ElevatedButton.styleFrom(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 30,
  //               ),
  //               elevation: 1,
  //               backgroundColor: Colors.red,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             child: const Text(
  //               "Redeem Now",
  //               style: TextStyle(
  //                 fontFamily: 'Inter',
  //                 color: Colors.white,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


  Widget _convertedLeadsContent() {
    if (leadList.isEmpty) {
      _loadLeads();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                'your_loans'.tr(),
                "₹0",
              ),
              const SizedBox(height: 8),
              _loanSummaryRow(
                'amount_disbursed'.tr(),
                "₹0",
              ),
            ],
          ),
        ),

        const SizedBox(height: 17),

        // ================= SELECT FILTER =================
        GestureDetector(
          onTap: () {
            // Filter action
          },
          child: Row(
            children: [
              const Icon(
                Icons.tune,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 7),
              Text(
                'select_filter'.tr(),
                style: const TextStyle(
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
        _buildConvertedLeadList()
        // ================= LOAN CARD 1 =================
      ],
    );
  }


  Widget _convertedLeadsContentV2() {
    if (!isConvertedCall) {
      if (loanGroups.isEmpty) {
        loadPage(_status);
      }
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _onRefresh,
          // Mirrors: if (response.loanGroups.isEmpty()) { GONE } else { VISIBLE, ... }
          child: isConvertedContentVisible
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      'your_loans'.tr(),
                      "₹0",
                    ),
                    const SizedBox(height: 8),
                    _loanSummaryRow(
                      'amount_disbursed'.tr(),
                      "₹0",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 17),

              // ================= SELECT FILTER =================
              GestureDetector(
                onTap: () {
                  // Filter action
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.tune,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'select_filter'.tr(),
                      style: const TextStyle(
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
              _buildConvertedLeadList()
              // ================= LOAN CARD 1 =================
            ],
          )
              : (isProgressVisible
              ? const SizedBox.shrink()
              : Center(child: Text('No converted leads'))
              // ListView(
              //   children: const [
              //     SizedBox(height: 120),
              //     Center(child: Text('No converted leads')),
              //   ],
              // )
          ),
        ),
        if (isProgressVisible)
          const Center(child: CircularProgressIndicator()),
      ],
    );
    // return
    //   Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Container(
    //       width: double.infinity,
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 12,
    //         vertical: 10,
    //       ),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         border: Border.all(
    //           color: Colors.red,
    //           width: 1,
    //         ),
    //         borderRadius: BorderRadius.circular(6),
    //       ),
    //       child: Column(
    //         children: [
    //           _loanSummaryRow(
    //             "Your Loans",
    //             "₹0",
    //           ),
    //           const SizedBox(height: 8),
    //           _loanSummaryRow(
    //             "Amount disbursed",
    //             "₹0",
    //           ),
    //         ],
    //       ),
    //     ),
    //
    //     const SizedBox(height: 17),
    //
    //     // ================= SELECT FILTER =================
    //     GestureDetector(
    //       onTap: () {
    //         // Filter action
    //       },
    //       child: Row(
    //         children: const [
    //           Icon(
    //             Icons.tune,
    //             size: 18,
    //             color: Colors.grey,
    //           ),
    //           SizedBox(width: 7),
    //           Text(
    //             "Select Filter",
    //             style: TextStyle(
    //               fontFamily: 'Inter',
    //               fontSize: 14,
    //               fontWeight: FontWeight.w400,
    //               color: Colors.grey,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //
    //     const SizedBox(height: 20),
    //     _buildConvertedLeadList()
    //     // ================= LOAN CARD 1 =================
    //   ],
    // );
  }

// ============================================================
// LEADS
// ============================================================
  Widget _leadsContent() {
    if (leadList.isEmpty) {
      _loadLeads();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= FILTER + SEARCH =================
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     GestureDetector(
        //       onTap: () {},
        //       child: Row(
        //         children: const [
        //           Icon(
        //             Icons.tune,
        //             size: 18,
        //             color: Colors.grey,
        //           ),
        //           SizedBox(width: 7),
        //           Text(
        //             "Select by date",
        //             style: TextStyle(
        //               fontFamily: 'Inter',
        //               fontSize: 16,
        //               fontWeight: FontWeight.w400,
        //               color: Colors.grey,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         // Search action
        //       },
        //       child: const Icon(
        //         Icons.search,
        //         size: 22,
        //         color: Colors.black54,
        //       ),
        //     ),
        //   ],
        // ),

        // const SizedBox(height: 14),

        // ================= LEADS LIST =================

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leadList.length,
          itemBuilder: (context, index) {
            final record = leadList[index];
            return _leadRow(pipelineRecord: record);
            // return _loanCard(pipelineRecord: record);
          },
        )
      ],
    );
  }

  Widget buildWalletSection(WalletResponse? wallet) {
    if (wallet == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          // ================= WALLET BALANCE =================
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              // bottom: 30,
            ),
            child: Column(
              children: [
                Text(
                  'wallet_balance'.tr(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF26344A),
                  ),
                ),

                // const SizedBox(height: 12),

                Text(
                  "₹${formatAmount(wallet.total)}",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB51B1B),
                  ),
                ),
              ],
            ),
          ),

          // ================= BLUE DIVIDER =================
          Container(
            height: 2,
            width: double.infinity,
            color: const Color(0xFFB51B1B),
          ),

          // ================= WALLET ROWS =================
          _walletRow(
            label: 'available_amount'.tr(),
            value: formatAmount(wallet.fund),
          ),

          _walletRow(
            label: 'total_withdrawn'.tr(),
            value: formatAmount(wallet.totalPaid),
          ),

          _walletRow(
            label: 'withdrawal_in_process'.tr(),
            value: formatAmount(wallet.withdrawable),
          ),

          _walletRow(
            label: 'onthly_rfd'.tr(),
            value: formatAmount(wallet.rfdMonthToDate),
            showBottomBorder: true,
          ),

          // ================= REDEEM BUTTON =================
          const SizedBox(height: 25),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 48,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(
          //             content: Text("Nothing to redeem yet"),
          //           ),
          //         );
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: const Color(0xFF2196F3),
          //         foregroundColor: Colors.white,
          //         elevation: 0,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //       ),
          //       child: const Text(
          //         "Redeem Now",
          //         style: TextStyle(
          //           fontFamily: 'Inter',
          //           fontSize: 15,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String formatAmount(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'\.00$'), '');
  }

  Widget _walletRow({
    required String label,
    required String value,
    bool showBottomBorder = false,
  }) {
    return Container(
      height: 36,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: showBottomBorder
              ? const BorderSide(
            color: Color(0xFFB51B1B),
            width: 2,
          )
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF26344A),
              ),
            ),
          ),

          Text(
            "₹$value",
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF26344A),
            ),
          ),
        ],
      ),
    );
  }


  Widget _leadRow({
    required PipelineRecord pipelineRecord,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFB51B1B),
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
              '${pipelineRecord.mobileNumber}',
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
              '${pipelineRecord.createdAt}',
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
}

Widget _loanSummaryRow(String title,
    String amount,) {
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
  required PipelineRecord pipelineRecord,
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
                "Loan ID:${pipelineRecord.id}",
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
                "Loan Status: ${pipelineRecord.currentStage}",
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
          "Loan Amount: ${'00000'}",
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        // Text(
        //   "Comment: $comment",
        //   style: const TextStyle(
        //     fontFamily: 'Inter',
        //     fontSize: 16,
        //     fontWeight: FontWeight.w700,
        //     color: Colors.black,
        //   ),
        // ),
      ],
    ),
  );
}
