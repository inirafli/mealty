import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key});

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

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
    if (picked != null && picked != (_startDate ?? _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unduh Rangkuman',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onBackground,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20.0,
                  color: onBackground,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Text(
            'Pilih rentang tanggal untuk mengunduh rangkuman pesanan:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: onBackground,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child:
                      _buildDateContainer(context, 'Dari', _startDate, true)),
              const SizedBox(width: 8.0),
              Icon(Icons.arrow_right_alt, color: primary),
              const SizedBox(width: 8.0),
              Expanded(
                  child:
                      _buildDateContainer(context, 'Sampai', _endDate, false)),
            ],
          ),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size(double.infinity, 40.0),
                disabledBackgroundColor: primary.withOpacity(0.15),
                padding: EdgeInsets.zero,
              ),
              onPressed: (_startDate != null && _endDate != null)
                  ? () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .downloadSummary(context, _startDate!, _endDate!);
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text(
                'Ya, Unduh',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onPrimary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildDateContainer(
      BuildContext context, String label, DateTime? date, bool isStart) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return GestureDetector(
      onTap: () => _selectDate(context, isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: onBackground),
        ),
        child: Text(
          date == null ? label : DateFormat('dd/MM/yyyy').format(date),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: onBackground, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
