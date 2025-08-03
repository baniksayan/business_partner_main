// File: lib/widgets/dialogs/stock_dialog_widget.dart
import 'package:flutter/material.dart';

class StockDialogWidget extends StatefulWidget {
  final VoidCallback onStockAdded;

  const StockDialogWidget({
    Key? key,
    required this.onStockAdded,
  }) : super(key: key);

  @override
  State<StockDialogWidget> createState() => _StockDialogWidgetState();
}

class _StockDialogWidgetState extends State<StockDialogWidget> {
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Stock'),
      content: TextField(
        controller: _stockController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter quantity to add',
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
            widget.onStockAdded();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Stock'),
        ),
      ],
    );
  }
}