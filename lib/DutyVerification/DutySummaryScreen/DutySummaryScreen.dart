// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:mysis/DutyVerification/AttendanceConsentScreen/AttendanceConsentScreen.dart';
// import 'package:mysis/constants/app_colors.dart';
//
// class DutySummaryScreen extends StatefulWidget {
//   const DutySummaryScreen({
//     super.key,
//   });
//
//   @override
//   State<DutySummaryScreen> createState() =>
//       _DutySummaryScreenState();
// }
//
// class _DutySummaryScreenState
//     extends State<DutySummaryScreen> {
//
//   // ============================================================
//   // DATE DATA
//   // ============================================================
//
//   final List<Map<String, String>> dutyList = [
//     {
//       "date": "11 September",
//       "day": "Fri",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "12 September",
//       "day": "Sat",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "13 September",
//       "day": "Sun",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "14 September",
//       "day": "Mon",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "15 September",
//       "day": "Tue",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "16 September",
//       "day": "Wed",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "17 September",
//       "day": "Thu",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "18 September",
//       "day": "Fri",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "19 September",
//       "day": "Sat",
//       "count": "0.0",
//       "status": "Pending",
//     },
//     {
//       "date": "20 September",
//       "day": "Sun",
//       "count": "0.0",
//       "status": "Pending",
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//
//       // ========================================================
//       // APP BAR
//       // ========================================================
//
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//
//         elevation: 0,
//
//         surfaceTintColor: Colors.transparent,
//
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             size: 15,
//             color: AppColors.red,
//           ),
//         ),
//
//         title: Text(
//           'duty_summary'.tr(),
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: AppColors.textPrimary,
//           ),
//         ),
//       ),
//
//       // ========================================================
//       // BODY
//       // ========================================================
//
//       body: SafeArea(
//         child: Column(
//           children: [
//
//             // ==================================================
//             // TOP SUMMARY
//             // ==================================================
//
//             _summarySection(),
//
//             // ==================================================
//             // TABLE
//             // ==================================================
//
//             Expanded(
//               child: Column(
//                 children: [
//
//                   // TABLE HEADER
//                   _tableHeader(),
//
//                   // TABLE DATA
//                   Expanded(
//                     child: ListView.builder(
//                       padding: EdgeInsets.zero,
//
//                       itemCount: dutyList.length,
//
//                       itemBuilder: (
//                           context,
//                           index,
//                           ) {
//                         return Text('DHGFsjgj');
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ==================================================
//             // NEXT BUTTON
//             // ==================================================
//
//             _nextButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // SUMMARY SECTION
//   // ============================================================
//
//   Widget _summarySection() {
//     return Container(
//       width: double.infinity,
//
//       color: AppColors.white,
//
//       // padding: const EdgeInsets.all(50),
//
//       child: Row(
//         children: [
//
//           // ====================================================
//           // DUTY APPROVED
//           // ====================================================
//
//           Expanded(
//             child: _summaryBox(
//               title: 'duty_approved'.tr(),
//               count: "0/10",
//               color: AppColors.green700,
//               background:
//               AppColors.white,
//               border: false,
//             ),
//           ),
//
//           const SizedBox(width: 6),
//
//           // ====================================================
//           // CLAIM
//           // ====================================================
//
//           Expanded(
//             child: _summaryBox(
//               title: 'claim'.tr(),
//               count: "0/10",
//               color: AppColors.white,
//               background:
//               AppColors.red700.withOpacity(0.75),
//               border: false,
//             ),
//           ),
//
//           const SizedBox(width: 6),
//
//           // ====================================================
//           // REJECTED
//           // ====================================================
//
//           Expanded(
//             child: _summaryBox(
//               title: 'rejected_tag'.tr(),
//               count: "0/10",
//               color: AppColors.white,
//               background:
//               AppColors.red,
//               border: false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // SUMMARY BOX
//   // ============================================================
//
//   Widget _summaryBox({
//     required String title,
//     required String count,
//     required Color color,
//     required Color background,
//     required bool border,
//   }) {
//     return Container(
//       height: 80,
//
//       decoration: BoxDecoration(
//         color: background,
//
//         border: border
//             ? Border.all(
//           color: AppColors.border,
//         )
//             : null,
//
//         borderRadius: BorderRadius.circular(2),
//       ),
//
//       child: Column(
//         mainAxisAlignment:
//         MainAxisAlignment.center,
//
//         children: [
//
//           Text(
//             title,
//             textAlign: TextAlign.center,
//
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//
//           const SizedBox(height: 7),
//
//           Text(
//             count,
//             style: TextStyle(
//               fontSize: 29,
//               fontWeight: FontWeight.w500,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // TABLE HEADER
//   // ============================================================
//
//   Widget _tableHeader() {
//     return Container(
//       height: 53,
//
//       width: double.infinity,
//
//       color: AppColors.red,
//
//       padding: const EdgeInsets.symmetric(
//         horizontal: 14,
//       ),
//
//       child: Row(
//         children: [
//
//           // DATE
//           Expanded(
//             flex: 4,
//
//             child: Text(
//               'date'.tr(),
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.white,
//               ),
//             ),
//           ),
//
//           // DUTY COUNT
//           Expanded(
//             flex: 3,
//
//             child: Text(
//               'duty_count'.tr(),
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.white,
//               ),
//             ),
//           ),
//
//           // STATUS
//           Expanded(
//             flex: 2,
//
//             child: Align(
//               alignment:
//               Alignment.centerRight,
//
//               child: Text(
//                 'status_tag'.tr(),
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // DUTY ROW
//   // ============================================================
//
//   Widget _dutyRow(
//       Map<String, String> data) {
//     return Container(
//       height: 104,
//
//       width: double.infinity,
//
//       padding: const EdgeInsets.symmetric(
//         horizontal: 14,
//       ),
//
//       decoration: BoxDecoration(
//         color: AppColors.background,
//
//         border: Border(
//           bottom: BorderSide(
//             color: AppColors.border,
//             width: 0.7,
//           ),
//         ),
//       ),
//
//       child: Row(
//         children: [
//
//           // ====================================================
//           // DATE
//           // ====================================================
//
//           Expanded(
//             flex: 4,
//
//             child: Column(
//               mainAxisAlignment:
//               MainAxisAlignment.center,
//
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//
//               children: [
//
//                 Text(
//                   data["date"] ?? "",
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color:
//                     AppColors.textPrimary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 Text(
//                   data["day"] ?? "",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color:
//                     AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // ====================================================
//           // DUTY COUNT
//           // ====================================================
//
//           Expanded(
//             flex: 3,
//
//             child: Text(
//               data["count"] ?? "0.0",
//
//               style: TextStyle(
//                 fontSize: 14,
//                 color:
//                 AppColors.textPrimary,
//               ),
//             ),
//           ),
//
//           // ====================================================
//           // STATUS
//           // ====================================================
//
//           Expanded(
//             flex: 2,
//
//             child: Align(
//               alignment:
//               Alignment.centerRight,
//
//               child: _statusBadge(
//                 data["status"] ?? "Pending",
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================================
//   // STATUS BADGE
//   // ============================================================
//
//   Widget _statusBadge(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 11,
//         vertical: 6,
//       ),
//
//       decoration: BoxDecoration(
//         color: AppColors.grey50,
//
//         borderRadius:
//         BorderRadius.circular(7),
//       ),
//
//       child: Text(
//         status,
//
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//           color: AppColors.textSecondary,
//         ),
//       ),
//     );
//   }
//
//   // ============================================================
//   // NEXT BUTTON
//   // ============================================================
//
//   Widget _nextButton() {
//     return Container(
//       width: double.infinity,
//
//       height: 45,
//
//       color: AppColors.red,
//
//       child: Material(
//         color: Colors.transparent,
//
//         child: InkWell(
//           onTap: () {
//
//
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) =>  AttendanceConsentScreen(),
//             //   ),
//             // );
//
//             // NEXT SCREEN
//             // Navigator.push(...);
//
//           },
//
//           child: Center(
//             child: Text(
//               'Duty_Summary_Next'.tr(),
//
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }