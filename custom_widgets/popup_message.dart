import 'package:flutter/material.dart';

class PopUpMessage {
  static bool _isPopupActive = false;
  
  static Future<void> showPopup({
    required BuildContext context,
    bool keepBarrier=true,
    String title='Sukses',
    String content='Data berhasil disimpan',
  }) async {
    // if (_isPopupActive && mounted) {
    //   Navigator.of(context).pop(true);
    // }
    if (_isPopupActive && keepBarrier) {
      return;
    }

    return await showDialog(
      barrierDismissible: !keepBarrier,
      context: context,
      builder: (ctx) {
        _isPopupActive = true;

        return WillPopScope(
          onWillPop: () async {
            return !keepBarrier;
          },
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 80),
            title: Text(title, style: const TextStyle(fontSize: 20),),
            content: Text(content),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            titlePadding: const EdgeInsets.only(left: 18, top: 8),
            actionsPadding: const EdgeInsets.only(bottom: 8, right: 12, top: 8),
            actions: [_closeButton(context)],
          ),
        );
      },
    ).then((value) {
      return value ?? false; // the value of "value" is taken from Navigator.of(context).pop(true/false);
    });
  }

  static Widget _closeButton(BuildContext context) {
    return FilledButton.tonal(
      child: const Text('OK'),
      onPressed:  () {
        _isPopupActive = false;
        if (context.mounted) {
          Navigator.of(context).pop(true);
        }

      },
    );
  }
}