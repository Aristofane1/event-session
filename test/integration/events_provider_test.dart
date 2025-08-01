import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_session/core/models/eventModel.dart';
import 'package:event_session/core/providers/event_provider.dart';
import 'package:event_session/core/repositories/event_repository.dart';
import 'package:event_session/services/api_service.dart';
import 'package:event_session/config/exceptions/api_exceptions.dart';

class MockEventRepository extends EventRepository {
  MockEventRepository() : super(MockApiService());

  @override
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      const EventModel(
        id: 1,
        name: 'Mock Event 1',
        description: 'Test event description',
        status: EventStatus.paid,
        eventDate: '2025-08-15',
        eventTime: '14:00',
        type: 'Workshop',
        photo: 'https://example.com/image.jpg',
        rate: 4.5,
        price: 50,
        isWaitingList: false,
        totalCurrentUser: 25,
        userGoal: 100,
        userId: 1,
        users: [1, 2, 3],
      ),
      const EventModel(
        id: 2,
        name: 'Mock Event 2',
        description: 'Another test event',
        status: EventStatus.upcoming,
        eventDate: '2025-08-20',
        eventTime: '18:00',
        type: 'Conference',
        photo: 'https://example.com/image2.jpg',
        rate: 4.0,
        price: 75,
        isWaitingList: true,
        totalCurrentUser: 10,
        userGoal: 50,
        userId: 2,
        users: [4, 5],
      ),
    ];
  }

  @override
  Future<List<EventModel>> getMyEvents() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final allEvents = await getEvents();
    // Return events for user with ID 1 (mock user events)
    return allEvents.where((event) => event.userId == 1).toList();
  }

  @override
  Future<dynamic> createEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock the API response like the real repository
    return {"name": "mock-event-key"};
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return event;
  }

  @override
  Future<void> deleteEvent(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock successful deletion
  }

  @override
  Future<void> uploadAttachment(int eventId, String filePath) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock successful upload
  }
}

class MockApiService extends ApiService {
  MockApiService() : super(baseUrl: 'https://mock.test.com');

  @override
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? query}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return {
      'event1': {
        'id': 1,
        'name': 'Mock Event 1',
        'status': 'paid',
        'description': 'Test event description',
        'location': 'Test Location',
        'price': 50.0,
      },
      'event2': {
        'id': 2,
        'name': 'Mock Event 2',
        'status': 'upcoming',
        'description': 'Another test event',
        'location': 'Another Location',
        'price': 75.0,
      },
    };
  }
}

class MockErrorEventRepository extends EventRepository {
  MockErrorEventRepository() : super(MockApiService());

  @override
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw ApiException('Failed to load events');
  }

  @override
  Future<List<EventModel>> getMyEvents() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw ApiException('Failed to load my events');
  }
}

void main() {
  group('EventProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          eventRepositoryProvider.overrideWithValue(MockEventRepository()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should load events successfully', () async {
      // Arrange - initial state should be loading
      final initialState = container.read(eventsProvider);
      expect(initialState, isA<AsyncLoading<List<EventModel>>>());

      // Act - trigger loading events
      await container.read(eventsProvider.notifier).loadEvents();

      // Assert - state should contain loaded events
      final loadedState = container.read(eventsProvider);
      expect(loadedState.hasValue, true);
      expect(loadedState.value, isA<List<EventModel>>());
      expect(loadedState.value!.length, 2);
      expect(loadedState.value!.first.name, 'Mock Event 1');
      expect(loadedState.value!.first.status, EventStatus.paid);
      expect(loadedState.value!.last.name, 'Mock Event 2');
      expect(loadedState.value!.last.status, EventStatus.upcoming);
    });

    test('should load my events successfully', () async {
      // Act - trigger loading my events
      await container.read(eventsProvider.notifier).loadMyEvents();

      // Assert - state should contain filtered events
      final loadedState = container.read(eventsProvider);
      expect(loadedState.hasValue, true);
      expect(loadedState.value, isA<List<EventModel>>());
      expect(loadedState.value!.length, 1);
      expect(loadedState.value!.first.userId, 1);
      expect(loadedState.value!.first.name, 'Mock Event 1');
    });

    test('should add event successfully', () async {
      // Arrange - load initial events
      await container.read(eventsProvider.notifier).loadEvents();

      // Act - add new event
      const newEvent = EventModel(
        name: 'Test Event',
        description: 'Test Description',
        status: EventStatus.upcoming,
        eventDate: '2025-09-01',
        eventTime: '16:00',
        type: 'Test',
        price: 25,
        userId: 1,
      );

      final result = await container
          .read(eventsProvider.notifier)
          .addEvent(newEvent);

      // Assert - addEvent should return true when successful
      expect(result, true);

      // Note: The real provider doesn't automatically update the list after adding
      // In a real app, you might need to call loadEvents() again or handle differently
    });

    test('eventByIdProvider should return correct event', () async {
      // Arrange - load events
      await container.read(eventsProvider.notifier).loadEvents();

      // Act - get event by ID
      final event = container.read(eventByIdProvider(1));

      // Assert - should return the correct event
      expect(event, isNotNull);
      expect(event!.id, 1);
      expect(event.name, 'Mock Event 1');
      expect(event.status, EventStatus.paid);
    });

    test(
      'eventByIdProvider should return null for non-existent event',
      () async {
        // Arrange - load events
        await container.read(eventsProvider.notifier).loadEvents();

        // Act - get non-existent event by ID
        final event = container.read(eventByIdProvider(999));

        // Assert - should return null
        expect(event, isNull);
      },
    );

    group('Error handling tests', () {
      late ProviderContainer errorContainer;

      setUp(() {
        errorContainer = ProviderContainer(
          overrides: [
            eventRepositoryProvider.overrideWithValue(
              MockErrorEventRepository(),
            ),
          ],
        );
      });

      tearDown(() {
        errorContainer.dispose();
      });

      test('should handle error when loading events fails', () async {
        // Act - trigger loading events with error repository
        await errorContainer.read(eventsProvider.notifier).loadEvents();

        // Assert - state should contain error
        final errorState = errorContainer.read(eventsProvider);
        expect(errorState.hasError, true);
        expect(errorState.error, isA<ApiException>());
        expect(
          (errorState.error as ApiException).message,
          'Failed to load events',
        );
      });

      test('should handle error when loading my events fails', () async {
        // Act - trigger loading my events with error repository
        await errorContainer.read(eventsProvider.notifier).loadMyEvents();

        // Assert - state should contain error
        final errorState = errorContainer.read(eventsProvider);
        expect(errorState.hasError, true);
        expect(errorState.error, isA<ApiException>());
        expect(
          (errorState.error as ApiException).message,
          'Failed to load my events',
        );
      });
    });
  });
}
