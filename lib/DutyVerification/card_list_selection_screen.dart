import 'package:flutter/material.dart';
import 'package:mysis/constants/app_colors.dart';

import 'models/missing_claim_models.dart';

/// Flutter replacement for CardListSelectionFragment.
/// One generic screen replaces SelectUnitScreen / SelectShiftScreen /
/// SelectPostScreen. It pops with the tapped item (the actual object).
///
///   final unit = await Navigator.push<UnitModel>(context,
///       MaterialPageRoute(builder: (_) => CardListSelectionScreen<UnitModel>(
///           title: 'Select Unit', items: units)));
class CardListSelectionScreen<T extends SelectableItem>
    extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selected;

  const CardListSelectionScreen({
    super.key,
    required this.title,
    required this.items,
    this.selected,
  });

  @override
  State<CardListSelectionScreen<T>> createState() =>
      _CardListSelectionScreenState<T>();
}

class _CardListSelectionScreenState<T extends SelectableItem>
    extends State<CardListSelectionScreen<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final list = widget.items
        .where((e) =>
            e.displayName.toLowerCase().contains(q) ||
            e.displaySubLabel.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.grey400,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.red, size: 15),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No data found'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final item = list[i];
                      final isSel = identical(item, widget.selected);
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.pop(context, item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSel ? AppColors.red : AppColors.border,
                              width: isSel ? 1.2 : 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.displayName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (item.displaySubLabel.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        item.displaySubLabel,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSel)
                                Icon(Icons.check_circle,
                                    color: AppColors.red, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
