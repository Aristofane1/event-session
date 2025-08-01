import 'dart:ui';

import 'package:event_session/config/themes/app_themes.dart';
import 'package:event_session/core/models/eventModel.dart';
import 'package:event_session/core/widgets/customButton.dart';
import 'package:event_session/main.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../config/app_assets.dart';
import '../providers/event_provider.dart';
import '../models/userModel.dart';
import '../widgets/custom_text.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/ratingSheet.dart';
import '../widgets/shareBottomSheet.dart';
import '../widgets/ticketBottomSheet.dart';
import 'eventPage.dart';
import 'reviewPage.dart';

class EventDetailsPage extends ConsumerWidget {
  final int eventId;
  const EventDetailsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventByIdProvider(eventId));
    // final notifier = ref.read(eventsProvider.notifier);
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: Image.asset(AppAssets.logo, height: 39.95, width: 36),
        title: CustomText(
          text: 'Event Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const ShareBottomSheet(),
              );
            },
            child: SizedBox(
              height: 56,
              width: 56,
              child: Center(
                child: Image.asset(
                  AppAssets.send,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.bg),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //   const Color(0xFFF5F1E8).withOpacity(0.85),
            //   BlendMode.overlay,
            // ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image de l'événement
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            fit: BoxFit.cover,
                            event!.photo!,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 3,
                            color: const Color(0x80FFFFFF),
                          ),
                        ),
                      ),
                      if (event.isCompleted)
                        Positioned(
                          top: 10,
                          right: 10,

                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x80060606),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1,
                                color: const Color(0x80FFFFFF),
                              ),
                            ),
                            child: CustomText(
                              text: event.status.displayName,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Contenu principal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre de l'événement
                        Text(
                          event.name!,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 24),

                        // Date et heure
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Image.asset(
                                AppAssets.calendarMark,
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("d MMMM yyyy, EEEE").format(
                                    DateTime.parse(
                                      "${event.eventDate} ${event.eventTime}",
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  """${DateFormat("HH:mm").format(DateTime.parse("${event.eventDate} ${event.eventTime}"))} - ${DateFormat("HH:mm").format(DateTime.parse("${event.eventDate} ${event.eventTime}"))}""",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                GestureDetector(
                                  child: CustomText(
                                    text: 'Add to calendar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppThemes.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Localisation
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Image.asset(
                                AppAssets.mapPoint,
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${event.address!.name}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${event.type}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  GestureDetector(
                                    child: CustomText(
                                      text: 'View on maps',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppThemes.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Capacité
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Image.asset(
                                AppAssets.usersGroup,
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event.totalCurrentUser}/${event.userGoal}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                if (event.totalCurrentUser! < event.userGoal!)
                                  Text(
                                    'You can take +1 person',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Event Details
                        CustomText(
                          text: 'Event Details',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),

                        SizedBox(height: 12),

                        CustomText(
                          text: "${event.description}",
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),

                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: EdgeInsets.only(left: 24, right: 24, top: 16),
        decoration: BoxDecoration(color: Color(0xFFFFF9EF)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  // Prix
                  Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    "€${event.price}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8F8D8A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            if ((event.users?.contains(user.id) ?? false) &&
                event.isWaitingList == false &&
                DateTime.parse(
                  "${event.eventDate} ${event.eventTime}",
                ).isBefore(DateTime.now()))
              Expanded(
                child: CustomButton(
                  text: "View reviews",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReviewsPage()),
                    );
                  },
                  color: AppThemes.secondaryColor,
                ),
              )
            else if (event.isWaitingList!)
              Expanded(
                child: CustomButton(
                  text: "Waiting list",
                  onPressed: () {
                    _showWaitingListBottomSheet(context);
                  },
                  color: AppThemes.secondaryColor,
                ),
              )
            else
              Expanded(
                child: CustomButton(
                  text: "Tickets",
                  onPressed: () {
                    _showTicketBottomSheet(context);
                  },
                  color: AppThemes.secondaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showWaitingListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CA3AF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                SizedBox(height: 30),

                // Position circle
                Stack(
                  children: [
                    Image.asset(
                      AppAssets.circleForNumber,
                      height: 137,
                      width: 137,
                    ),
                    Positioned(
                      left: 1,
                      right: 1,
                      top: 1,
                      bottom: 1,
                      child: Center(
                        child: CustomText(
                          text: '07',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // Title
                CustomText(
                  text: 'Your position in\nwaiting list is 07!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                    height: 1.3,
                  ),
                ),

                // Description
                CustomText(
                  text:
                      'Thank you for your interest in our event! Due to high demand, we have reached full capacity, but you can join our waiting list to be notified if a spot become available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF8F8D8A),
                    height: 1.5,
                  ),
                ),

                // Checkbox option
                CheckboxListTile.adaptive(
                  value: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (onChanged) {
                    // Handle checkbox change
                  },
                  title: CustomText(
                    text: '+1 will be with me',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),

                SizedBox(height: 30),

                // Begin button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Begin",
                    onPressed: () {},
                    color: AppThemes.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTicketBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return TicketBottomSheet(eventID: eventId);
      },
    );
  }
}
