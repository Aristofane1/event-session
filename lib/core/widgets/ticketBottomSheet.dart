import 'dart:ui';

import 'package:event_session/core/widgets/customButton.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_assets.dart';
import '../../config/themes/app_themes.dart';
import '../../main.dart';
import '../models/eventModel.dart';
import '../providers/event_provider.dart';
import '../views/eventDetailPage.dart';
import 'custom_text.dart';
import 'event_card_widget.dart';
import 'success_dialog.dart';

class TicketBottomSheet extends ConsumerStatefulWidget {
  final int eventID;
  const TicketBottomSheet({super.key, required this.eventID});
  @override
  TicketBottomSheetState createState() => TicketBottomSheetState();
}

class TicketBottomSheetState extends ConsumerState<TicketBottomSheet> {
  int ticketCount = 1;
  bool plusOneSelected = true;
  bool isLoading = false;
  String selectedPayment = 'Apple Pay';

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventByIdProvider(widget.eventID));

    final notifier = ref.read(eventsProvider.notifier);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9EF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 20),
            EventCardWidget(
              eventId: event!.id!,
              withDecoration: false,
              isDialog: true,
            ),

            // Event card
            Divider(color: Color(0x1863605C), height: 2),
            SizedBox(height: 8),

            // Choose the ticket
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Choose the ticket',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (ticketCount > 1) {
                          setState(() {
                            ticketCount--;
                          });
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9EF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: AppThemes.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '$ticketCount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ticketCount++;
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9EF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppThemes.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // +1 will be with me
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '+1 will be with me',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      plusOneSelected = !plusOneSelected;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: plusOneSelected
                          ? AppThemes.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: plusOneSelected
                            ? AppThemes.primaryColor
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: plusOneSelected
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
              ],
            ),

            // Full name field
            TextField(
              decoration: InputDecoration(
                hintText: 'Full name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppThemes.primaryColor),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Promo Code
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Promo Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            TextField(
              style: TextStyle(),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'YOUR PROMO CODE',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppThemes.primaryColor),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Payment methods
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Payment methods',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Apple Pay option
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPayment = 'Apple Pay';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedPayment == 'Apple Pay'
                            ? Color(0xFFFFE8A3)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedPayment == 'Apple Pay'
                              ? Color(0xFFFFD966)
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: selectedPayment == 'Apple Pay'
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
                    Text(
                      'Apple Play',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Spacer(),
                    Image.asset(AppAssets.applePay, height: 19, width: 41),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8),

            // Credit Card option
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPayment = 'Credit Card';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedPayment == 'Credit Card'
                            ? Color(0xFFFFE8A3)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedPayment == 'Credit Card'
                              ? Color(0xFFFFD966)
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: selectedPayment == 'Credit Card'
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
                    Text(
                      'Credit Card',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Image.asset(AppAssets.visa, height: 14, width: 45),
                        SizedBox(width: 8),
                        Image.asset(
                          AppAssets.mastercard,
                          height: 25,
                          width: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),

            // Begin button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Begin",
                isLoading: isLoading,
                onPressed: () async {
                  if (!isLoading) {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      var resp = await notifier.addEvent(event);

                      if (!mounted) return;

                      if (resp == true) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        NotificationController.showNotif(
                          title: "Payment Successful",
                          body:
                              "Prepare yourself to join us for the big event of year :)",
                        );
                        _showPaymentSuccessDialog(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Payment failed. Please try again."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("An error occurred. Please try again."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  }
                },
                color: AppThemes.secondaryColor,
              ),
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Payment was\nsuccessful!',
          message: 'We are waiting for\nyou at the event.',
        );
      },
    );
  }

  void _showEventCongrateDialog(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            padding: EdgeInsets.all(20),
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

                // Event
                EventCardWidget(
                  eventId: event.id!,
                  withDecoration: false,
                  isDialog: true,
                ),
                Divider(color: Color(0x1863605C), height: 2),

                SizedBox(height: 32),

                // Success title
                Text(
                  "Congratulations,\nit's your turn!",
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
                  'It is necessary to pay for the ticket in order not to miss the opportunity to visit',
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
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Refuse",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonStyle: ButtonStyle.outlined,
                          color: AppThemes.primaryColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: "Go to pay",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: AppThemes.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
