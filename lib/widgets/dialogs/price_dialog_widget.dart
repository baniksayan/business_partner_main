// File: lib/widgets/dialogs/price_dialog_widget.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';

class PriceDialogWidget extends StatefulWidget {
  final Product product;
  final VoidCallback onPriceUpdated;

  const PriceDialogWidget({
    Key? key,
    required this.product,
    required this.onPriceUpdated,
  }) : super(key: key);

  @override
  State<PriceDialogWidget> createState() => _PriceDialogWidgetState();
}

class _PriceDialogWidgetState extends State<PriceDialogWidget> {
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.product.price.replaceAll('₹', ''),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Update Price'),
      content: TextField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter new price',
          prefixText: '₹ ',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onPriceUpdated();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
          ),
          child: const Text('Update Price'),
        ),
      ],
    );
  }
}