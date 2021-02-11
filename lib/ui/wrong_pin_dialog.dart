import 'package:flutter/material.dart';

class WrongPinDialog extends StatelessWidget {
  const WrongPinDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
        scrollable: true,
        title: const Text('No data exists with this PIN!'),
        content: const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Would you like to create a new database and remove existing ones?')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('NO, TRY AGAIN', style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('YES, CREATE', style: TextStyle(color: Colors.red)))
        ],
      );
}
