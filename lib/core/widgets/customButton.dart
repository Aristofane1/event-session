import 'package:event_session/config/themes/app_themes.dart';
import 'package:flutter/material.dart';

enum ButtonStyle { elevated, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle buttonStyle;
  final Color color;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double elevation;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonStyle = ButtonStyle.elevated,
    this.color = AppThemes.primaryColor,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderRadius = 16,
    this.elevation = 1,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: buttonStyle == ButtonStyle.elevated
          ? _buildElevatedButton()
          : _buildOutlinedButton(),
    );
  }

  Widget _buildElevatedButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
      ),
      child: isLoading
          ? SizedBox(
              height: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: padding,
        side: BorderSide(color: color, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
      ),
      child: isLoading
          ? SizedBox(
              height: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
    );
  }
}
