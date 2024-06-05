import 'package:flutter/material.dart';

class PriceInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isEditable;

  const PriceInput({
    required this.controller,
    required this.isEditable,
    super.key,
  });

  @override
  State<PriceInput> createState() => _PriceInputState();
}

class _PriceInputState extends State<PriceInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleInputChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleInputChange);
    super.dispose();
  }

  void _handleInputChange() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '0';
      widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length));
    } else if (widget.controller.text != '0' &&
        widget.controller.text.startsWith('0')) {
      widget.controller.text = widget.controller.text.substring(1);
      widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length));
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
          'Harga Makanan',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Container(
              height: 38.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: primary,
                border: Border(
                  top: BorderSide(color: primary),
                  left: BorderSide(color: primary),
                  bottom: BorderSide(color: primary),
                  right: BorderSide.none, // No border on the right side
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              child: Text(
                'Rp.',
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
                  enabled: widget.isEditable,
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
                  onTap: () {
                    if (widget.controller.text == '0') {
                      widget.controller.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
