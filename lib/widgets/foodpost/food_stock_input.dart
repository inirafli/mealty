import 'package:flutter/material.dart';

class StockInput extends StatefulWidget {
  final TextEditingController controller;

  const StockInput({required this.controller, super.key});

  @override
  State<StockInput> createState() => _StockInputState();
}

class _StockInputState extends State<StockInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleInputChange);
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '1';
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleInputChange);
    super.dispose();
  }

  void _handleInputChange() {
    if (widget.controller.text.isEmpty) {
      return;
    }
    int value = int.tryParse(widget.controller.text) ?? 0;
    if (value == 0) {
      widget.controller.text = '1';
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
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
          'Jumlah Makanan',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Container(
              width: 45.0,
              height: 39.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: primary,
                border: Border.all(color: primary),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              child: Text(
                'Qty.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 38.0,
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 16.0, right: 8.0, bottom: 0, top: 21.5),
                    filled: true,
                    fillColor: onPrimary,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: primary,
                        width: 0.75,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: primary,
                        width: 1.0,
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
      ],
    );
  }
}
