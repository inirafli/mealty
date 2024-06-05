import 'package:flutter/material.dart';

class SellingTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelectType;

  const SellingTypeSelector({
    required this.selectedType,
    required this.onSelectType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipe Unggahan',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onSelectType('commercial'),
                child: Container(
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: selectedType == 'commercial' ? primary : onPrimary,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Komersil',
                      style: TextStyle(
                        color:
                            selectedType == 'commercial' ? onPrimary : primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: GestureDetector(
                onTap: () => onSelectType('sharing'),
                child: Container(
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: selectedType == 'sharing' ? primary : onPrimary,
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Berbagi',
                      style: TextStyle(
                        color: selectedType == 'sharing' ? onPrimary : primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        if (selectedType == 'commercial')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipe Komersil digunakan untuk melakukan penjualan makanan dengan harga yang telah ditentukan.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: onBackground,
                    fontStyle: FontStyle.italic),
              ),
            ],
          )
        else if (selectedType == 'sharing')
          Text(
            'Tipe Berbagi digunakan untuk membagikan makanan secara gratis atau tanpa bayaran.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: onBackground,
                fontStyle: FontStyle.italic),
          ),
      ],
    );
  }
}
