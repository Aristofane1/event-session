import 'package:event_session/config/themes/app_themes.dart';
import 'package:event_session/core/widgets/customButton.dart';
import 'package:flutter/material.dart' hide ButtonStyle;

class CancelBookingBottomSheet extends StatefulWidget {
  final bool short;
  final Function(String reason, String comment, BuildContext context)? onCancel;

  const CancelBookingBottomSheet({
    super.key,
    this.short = false,
    this.onCancel,
  });

  @override
  State<CancelBookingBottomSheet> createState() =>
      _CancelBookingBottomSheetState();
}

class _CancelBookingBottomSheetState extends State<CancelBookingBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final int _maxCharacters = 2000;
  String selectedReason = "";
  bool _isLoading = false;
  final List<String> reasonList = [
    "I have another event, so it colides",
    "I’m sick, can’t come",
    "I have an urgent need",
    "I have no transportation to come",
    "I have no friends to come",
    "I want to book another event",
    "I just want to cancel",
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleCancel() async {
    if (!widget.short && selectedReason.isEmpty) {
      // Afficher un message d'erreur si aucune raison n'est sélectionnée
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a reason for cancellation'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Appeler le callback avec les paramètres
      if (widget.onCancel != null) {
        await widget.onCancel!(
          widget.short ? "Quick cancellation" : selectedReason,
          _commentController.text.trim(),
          context,
        );
      }
    } catch (e) {
      // Gérer l'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleKeepBooking() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Si short est true, on retourne le contenu simple
    if (widget.short) {
      return _buildShortContent();
    }

    // Sinon on retourne le contenu de _cancellingDescriptionSheet
    return _buildLongContent();
  }

  Widget _buildShortContent() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Cancel Booking',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Are you sure you want to cancel your reservation for this event?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Don't Cancel",
                  onPressed: _handleKeepBooking,
                  color: AppThemes.primaryColor,
                  buttonStyle: ButtonStyle.outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "Yes, Cancel",
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleCancel,
                  color: AppThemes.secondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLongContent() {
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Cancel Booking',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            'Please select the reason for cancellation:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ...reasonList.map((reason) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedReason = reason;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedReason == reason
                            ? Color(0xFFFFE8A3)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedReason == reason
                              ? Color(0xFFFFD966)
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: selectedReason == reason
                          ? Center(
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppThemes.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        reason,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Text field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: _maxCharacters,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                counterText: '',
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 8),

          // Character counter
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_commentController.text.length}/$_maxCharacters maximum characters allowed',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Don't Cancel",
                  onPressed: _isLoading ? null : _handleKeepBooking,
                  color: AppThemes.primaryColor,
                  buttonStyle: ButtonStyle.outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "Yes, Cancel",
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleCancel,
                  color: AppThemes.secondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
