import 'package:event_session/core/widgets/cancelBookingSheet.dart';
import 'package:event_session/core/widgets/customButton.dart';
import 'package:event_session/core/widgets/custom_text.dart';
import 'package:event_session/main.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/app_assets.dart';
import '../../config/themes/app_themes.dart';
import '../providers/event_provider.dart';
import '../models/eventModel.dart';
import '../views/eventDetailPage.dart' hide SuccessDialog;
import '../views/reviewPage.dart';
import 'success_dialog.dart';

class EventCardWidget extends ConsumerWidget {
  final int eventId;
  final bool? withDecoration;
  final bool? isDialog;
  final bool? isMine;
  const EventCardWidget({
    super.key,
    required this.eventId,
    this.withDecoration = true,
    this.isDialog = false,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventByIdProvider(eventId));
    final notifier = ref.read(eventsProvider.notifier);
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: withDecoration != null && withDecoration == true
          ? BoxDecoration(
              color: event!.status != EventStatus.completed || isMine!
                  ? Color(0xFFFFF9EF)
                  : const Color(0x1A63605C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 3, color: const Color(0x7EFFFFFF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            )
          : null,
      child: Column(
        children: [
          Row(
            children: [
              // Event image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 143,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(event!.photo!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Event details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.calendarMark,
                                height: 16,
                                width: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                DateFormat('d MMM • h:mm a').format(
                                  DateTime.parse(
                                    "${event.eventDate} ${event.eventTime}",
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: isDialog! ? 9 : 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${event.type}",
                            style: TextStyle(
                              fontSize: isDialog! ? 9 : 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Event title
                      CustomText(
                        text: "${event.name}",
                        style: TextStyle(
                          fontSize: isDialog! ? 14 : 18,
                          fontWeight: FontWeight.bold,
                          color: event.status == EventStatus.completed
                              ? Color(0x9963605C)
                              : Colors.black87,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 12),

                      // Rating and status
                      if (event.status == EventStatus.completed && !isMine!)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.starFill,
                                  height: 16,
                                  width: 16,
                                ),
                                CustomText(
                                  text: "${event.rate}",
                                  style: TextStyle(
                                    fontSize: isDialog! ? 9 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            CustomText(
                              text: 'View',
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              color: AppThemes.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                event.status.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.ticket,
                                  height: 16,
                                  width: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  event.price == 0
                                      ? 'Free'
                                      : '\$${event.price}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            isMine!
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: event.status.color,
                                    ),
                                    child: CustomText(
                                      text: event.status.displayName,
                                      color: Colors.white,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!isDialog! && isMine!) ...[
            Divider(color: Color(0x1863605C), height: 2),
            SizedBox(height: 8),
            event.status == EventStatus.paid
                ? Padding(
                    padding: EdgeInsets.all(6),
                    child: CustomButton(
                      text: "Cancel Booking",
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return CancelBookingBottomSheet(
                              short: false,
                              onCancel: (reason, description, ctx) async {
                                await Future.delayed(Duration(seconds: 1));
                                // await notifier.updateEvent(event);
                                await notifier.loadMyEvents();
                                Navigator.pop(ctx);
                                NotificationController.showNotif(
                                  title: 'Oh !!! :)',
                                  body: 'Your booking has been canceled.',
                                );
                                showDialog(
                                  context: ctx,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return SuccessDialog(
                                      title: 'Successful!',
                                      message:
                                          'You have successfully canceled the event. 80% of the fonds will be returned to your account.',
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      color: AppThemes.primaryColor,
                      buttonStyle: ButtonStyle.outlined,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(6),
                    child: CustomButton(
                      text: "Reviews",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewsPage(),
                          ),
                        );
                      },
                      color: AppThemes.secondaryColor,
                    ),
                  ),
          ],
        ],
      ),
    );
  }
}
