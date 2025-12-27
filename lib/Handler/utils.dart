
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class Utils {
  Utils._();

  static void showCupertinoToast(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Transparent background
      builder: (context) {
        // Auto-dismiss after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if(!context.mounted)return;
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        });

        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                color: CupertinoColors.systemGrey6.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.check_mark, size: 40, color: CupertinoColors.systemGrey),
                    const SizedBox(height: 8),
                    Text(message, style: const TextStyle(decoration: TextDecoration.none, fontSize: 16, color: CupertinoColors.label)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}