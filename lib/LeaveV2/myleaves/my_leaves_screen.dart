/*
 * Created by Ashu Rajput on 22-10-2026.
 */

import 'package:flutter/material.dart';

import '../../common/widgets/common_text.dart';
import '../../constants/app_colors.dart';
import 'leave_filter_chips.dart';
import 'leave_history_item.dart';
import 'leave_status_badge.dart';

class MyLeavesScreen extends StatefulWidget {
  const MyLeavesScreen({super.key});

  @override
  State<MyLeavesScreen> createState() => _MyLeavesScreenState();
}

class _MyLeavesScreenState extends State<MyLeavesScreen> {
  int _selectedFilter = 0; // 0=All, 1=Pending, 2=Approved, 3=Rejected

  // Static data matching the screenshot (UI only)
  final List<_LeaveGroup> _allGroups = [
    _LeaveGroup(
      title: 'October',
      items: [
        _LeaveItem(
          isEmergency: false,
          dateRange: '28 sep - 6 oct',
          reason: 'Farming work',
          duration: '9 days',
          status: LeaveStatus.pending,
        ),
        _LeaveItem(
          isEmergency: false,
          dateRange: '24 - 26 Oct',
          reason: 'Festival',
          duration: '3 days',
          status: LeaveStatus.approved,
        ),
      ],
    ),
    _LeaveGroup(
      title: 'August',
      items: [
        _LeaveItem(
          isEmergency: true,
          dateRange: '14 Aug',
          reason: 'Sick',
          duration: '1 day',
          status: LeaveStatus.approved,
        ),
      ],
    ),
    _LeaveGroup(
      title: 'Earlier',
      items: [
        _LeaveItem(
          isEmergency: false,
          dateRange: '20 - 22 Jun',
          reason: 'Festival',
          duration: '3 days',
          status: LeaveStatus.rejected,
        ),
        _LeaveItem(
          isEmergency: true,
          dateRange: '2 - 3 May',
          reason: 'Family Emergency',
          duration: '2 days',
          status: LeaveStatus.approved,
        ),
        _LeaveItem(
          isEmergency: false,
          dateRange: '12 Apr',
          reason: 'Festival',
          duration: '1 days',
          status: LeaveStatus.approved,
        ),
      ],
    ),
  ];

  List<_LeaveGroup> get _filteredGroups {
    if (_selectedFilter == 0) return _allGroups;

    final LeaveStatus targetStatus;
    switch (_selectedFilter) {
      case 1:
        targetStatus = LeaveStatus.pending;
        break;
      case 2:
        targetStatus = LeaveStatus.approved;
        break;
      case 3:
        targetStatus = LeaveStatus.rejected;
        break;
      default:
        return _allGroups;
    }

    return _allGroups
        .map((group) {
          final filteredItems =
              group.items.where((item) => item.status == targetStatus).toList();
          if (filteredItems.isEmpty) return null;
          return _LeaveGroup(title: group.title, items: filteredItems);
        })
        .whereType<_LeaveGroup>()
        .toList();
  }

  int get _pendingCount {
    int count = 0;
    for (final group in _allGroups) {
      count += group.items.where((e) => e.status == LeaveStatus.pending).length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filteredGroups;

    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const LabelText(
          'My Leaves',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Filter chips
          LeaveFilterChips(
            selectedIndex: _selectedFilter,
            pendingCount: _pendingCount,
            onSelected: (index) {
              setState(() => _selectedFilter = index);
            },
          ),

          const SizedBox(height: 16),

          // List
          Expanded(
            child: groups.isEmpty
                ? const Center(
                    child: SubLabelText(
                      'No leaves found',
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: groups.length,
                    itemBuilder: (context, groupIndex) {
                      final group = groups[groupIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month header
                          Padding(
                            padding: EdgeInsets.only(
                              top: groupIndex == 0 ? 0 : 8,
                              bottom: 10,
                            ),
                            child: SubLabelText(
                              group.title,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey700,
                            ),
                          ),

                          // Items
                          ...group.items.map(
                            (item) => LeaveHistoryItem(
                              isEmergency: item.isEmergency,
                              dateRange: item.dateRange,
                              reason: item.reason,
                              duration: item.duration,
                              status: item.status,
                              onTap: () {
                                // TODO: Navigate to leave detail
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------- Private models (UI only) ----------

class _LeaveGroup {
  final String title;
  final List<_LeaveItem> items;

  _LeaveGroup({required this.title, required this.items});
}

class _LeaveItem {
  final bool isEmergency;
  final String dateRange;
  final String reason;
  final String duration;
  final LeaveStatus status;

  _LeaveItem({
    required this.isEmergency,
    required this.dateRange,
    required this.reason,
    required this.duration,
    required this.status,
  });
}
