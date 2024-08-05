import 'package:flutter/material.dart';

class CustomSnackbar {
  static void snack(BuildContext context, String message,
      {Color? color, int? duration, double? fontSize}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration != null
            ? Duration(seconds: duration)
            : const Duration(seconds: 3),
        closeIconColor: color != null
            ? Colors.white
            : Theme.of(context).colorScheme.onPrimary,
        backgroundColor: color,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            message,
            style: TextStyle(
              color: color != null
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimary,
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ),
    );
  }
}
