import 'package:event_session/core/widgets/customButton.dart';
import 'package:flutter/material.dart';

import '../../config/app_assets.dart';
import '../../config/themes/app_themes.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  const SuccessDialog({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9EF),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Success icon with circles
            Image.asset(AppAssets.successCheck),

            SizedBox(height: 32),

            // Success title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3,
              ),
            ),

            SizedBox(height: 16),

            // Success message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),

            SizedBox(height: 32),

            // OK button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "OK",
                onPressed: () {
                  Navigator.pop(context);
                },
                color: AppThemes.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
