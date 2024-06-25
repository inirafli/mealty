import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class SaleTimeInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(DateTime) onSelectDateTime;
  final DateTime? initialDateTime;

  const SaleTimeInput({
    required this.controller,
    required this.onSelectDateTime,
    this.initialDateTime,
    super.key,
  });

  @override
  State<SaleTimeInput> createState() => _SaleTimeInputState();
}

class _SaleTimeInputState extends State<SaleTimeInput> {
  Future<void> _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDate = widget.initialDateTime ?? now;
    DateTime firstDate = initialDate.isBefore(now) ? initialDate : now;
    TimeOfDay initialTime = widget.initialDateTime != null
        ? TimeOfDay(
        hour: widget.initialDateTime!.hour,
        minute: widget.initialDateTime!.minute)
        : TimeOfDay.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
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

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
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

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        widget.controller.text =
        "${DateFormat.yMMMMd('en_US').add_jms().format(finalDateTime)} UTC+7";
        widget.onSelectDateTime(finalDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diunggah Sampai',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _selectDateTime(context),
          child: Row(
            children: [
              Container(
                width: 45.0,
                height: 39.0,
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: primary,
                  border: Border(
                    top: BorderSide(color: primary),
                    left: BorderSide(color: primary),
                    bottom: BorderSide(color: primary),
                    right: BorderSide.none,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                ),
                child: Icon(
                  MdiIcons.calendarRange,
                  size: 18.0,
                  color: onPrimary,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 38.0,
                  child: TextField(
                    controller: widget.controller,
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 16.0, right: 8.0, bottom: 0, top: 21.5),
                      filled: true,
                      fillColor: onPrimary,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                          color: primary,
                          width: 0.75,
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}