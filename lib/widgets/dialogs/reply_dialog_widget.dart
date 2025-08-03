// File: lib/widgets/dialogs/reply_dialog_widget.dart
import 'package:flutter/material.dart';

class ReplyDialogWidget extends StatefulWidget {
  final String customerName;
  final VoidCallback onReplySent;

  const ReplyDialogWidget({
    Key? key,
    required this.customerName,
    required this.onReplySent,
  }) : super(key: key);

  @override
  State<ReplyDialogWidget> createState() => _ReplyDialogWidgetState();
}

class _ReplyDialogWidgetState extends State<ReplyDialogWidget> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Reply to ${widget.customerName}'),
      content: TextField(
        controller: _replyController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Type your reply...',
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
            widget.onReplySent();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
          ),
          child: const Text('Send Reply'),
        ),
      ],
    );
  }
}