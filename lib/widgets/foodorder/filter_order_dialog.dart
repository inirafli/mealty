import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../provider/order_provider.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedFilter = 'allDate';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _selectedFilter = orderProvider.filterDate;
    _startDate = orderProvider.startDate;
    _endDate = orderProvider.endDate;
  }

  void _applyFilter(BuildContext context) {
    if (_selectedFilter == 'customDate' && (_startDate == null || _endDate == null)) {
      return;
    }

    Provider.of<OrderProvider>(context, listen: false).setDateFilter(
      filter: _selectedFilter,
      startDate: _startDate,
      endDate: _endDate,
    );
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onBackground,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildDateContainer(BuildContext context, String label, DateTime? date, bool isStart) {
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return GestureDetector(
      onTap: () => _selectDate(context, isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          date == null ? label : DateFormat('dd/MM/yyyy').format(date),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: onBackground,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, String filter) {
    final bool isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        height: 38.0,
        padding: const EdgeInsets.only(left: 14.0, right: 16.0, top: 6.0, bottom: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Tanggal Pesanan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20.0,
                  color: primary,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: [
              _buildFilterButton(context, 'Semua', 'allDate'),
              _buildFilterButton(context, '7 Hari', '7days'),
              _buildFilterButton(context, '15 Hari', '15days'),
              _buildFilterButton(context, '30 Hari', '30days'),
              _buildFilterButton(context, 'Custom Tanggal', 'customDate'),
            ],
          ),
          const SizedBox(height: 24.0),
          if (_selectedFilter == 'customDate')
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildDateContainer(context, 'Dari', _startDate, true)),
                const SizedBox(width: 8.0),
                Icon(Icons.arrow_right_alt, color: primary),
                const SizedBox(width: 8.0),
                Expanded(child: _buildDateContainer(context, 'Sampai', _endDate, false)),
              ],
            ),
          const SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size(double.infinity, 40.0),
                padding: EdgeInsets.zero,
              ),
              onPressed: (_selectedFilter == 'customDate' && (_startDate == null || _endDate == null))
                  ? null
                  : () {
                _applyFilter(context);
              },
              child: Text(
                'Terapkan Filter',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}