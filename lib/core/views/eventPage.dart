import 'package:event_session/config/app_assets.dart';
import 'package:event_session/config/themes/app_themes.dart';
import 'package:event_session/core/views/eventDetailPage.dart';
import 'package:event_session/core/widgets/customButton.dart';
import 'package:event_session/core/widgets/filterSheet.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/event_provider.dart';
import '../widgets/custom_text.dart';
import '../widgets/event_card_widget.dart';

class EventPage extends ConsumerStatefulWidget {
  const EventPage({super.key});

  @override
  ConsumerState<EventPage> createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  bool isAllEventsSelected = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Delay the provider modification to avoid modifying during widget tree building
    Future(() {
      ref.read(eventsProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final notifier = ref.read(eventsProvider.notifier);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Image.asset(AppAssets.logo, height: 39.95, width: 36),
        title: CustomText(
          text: 'Event',
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
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) {
                  return FilterBottomSheet();
                },
              );
            },
            child: SizedBox(
              height: 56,
              width: 56,
              child: Image.asset(AppAssets.filter, height: 25.41, width: 24),
            ),
          ),
        ],
      ),
      body: Container(
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
          child: Column(
            children: [
              // Toggle buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAllEventsSelected = true;
                            notifier.loadEvents();
                          });
                        },
                        child: Container(
                          height: 39,
                          decoration: BoxDecoration(
                            color: isAllEventsSelected
                                ? AppThemes.primaryColor
                                : Color(0xFFFFF2CF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomText(
                              text: 'All events',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isAllEventsSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAllEventsSelected = false;
                            notifier.loadMyEvents();
                          });
                        },
                        child: Container(
                          height: 39,
                          decoration: BoxDecoration(
                            color: !isAllEventsSelected
                                ? AppThemes.primaryColor
                                : Color(0xFFFFF2CF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomText(
                              text: 'My events',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isAllEventsSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Empty state content
              Expanded(
                child: eventsAsync.when(
                  data: (events) {
                    if (events.isEmpty) {
                      return blackListWidget();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailsPage(
                                  eventId: events[index].id!,
                                ),
                              ),
                            );
                          },
                          child: EventCardWidget(
                            eventId: events[index].id!,
                            isMine: !isAllEventsSelected,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => blackListWidget(),
                ),
                // blackListWidget()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column blackListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.noEvent, height: 137, width: 137),

        SizedBox(height: 25),

        // Title text
        CustomText(
          text: 'No events for you :(',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),

        SizedBox(height: 15),

        // Description text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Sorry, events are not available for you,\nyou are in the black list, contact support\nfor a solution',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),

        SizedBox(height: 24),

        // Contact support button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Contact support",
              onPressed: () {},
              color: AppThemes.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
