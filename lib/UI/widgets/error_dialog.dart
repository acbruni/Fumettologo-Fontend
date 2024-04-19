import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          child: const Center(child: Text('Chiudi')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  });
}
