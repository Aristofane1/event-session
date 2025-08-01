import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eventModel.dart';
import '../repositories/event_repository.dart';
import '../../../services/api_service.dart';
import '../../../config/exceptions/api_exceptions.dart';

/// Fournisseur global d'ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    baseUrl: 'https://event-session-default-rtdb.firebaseio.com/event-session',
  );
});

/// Fournisseur global de EventRepository
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final api = ref.read(apiServiceProvider);
  return EventRepository(api);
});

/// Provider d'état pour les événements avec pagination
final eventsProvider =
    StateNotifierProvider<EventNotifier, AsyncValue<List<EventModel>>>((ref) {
      final repository = ref.read(eventRepositoryProvider);
      return EventNotifier(repository);
    });

final eventByIdProvider = Provider.family<EventModel?, int>((ref, id) {
  final events = ref.watch(eventsProvider).value;
  if (events == null) return null;
  try {
    return events.firstWhere((event) => event.id == id);
  } catch (e) {
    return null;
  }
});

class EventNotifier extends StateNotifier<AsyncValue<List<EventModel>>> {
  final EventRepository repository;

  EventNotifier(this.repository) : super(const AsyncLoading()) {
    loadEvents();
  }

  List<EventModel> get currentEvents => state.value ?? [];

  Future<void> loadEvents() async {
    state = const AsyncLoading();

    try {
      final events = await repository.getEvents();
      state = AsyncData(events);
    } on ApiException catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> loadMyEvents() async {
    state = const AsyncLoading();

    try {
      final events = await repository.getMyEvents();
      state = AsyncData(events);
    } on ApiException catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Ajouter une tâche
  Future<dynamic> addEvent(EventModel event) async {
    try {
      final newEvent = await repository.createEvent(event);
      if (newEvent["name"] != null) {
        return true;
      }
    } on ApiException catch (e) {
      // À toi de gérer dans l’UI si besoin
      rethrow;
    }
  }

  /// Modifier une tâche
  Future<void> updateEvent(EventModel event) async {
    try {
      final updated = await repository.updateEvent(event);
      state = AsyncData([
        for (final t in currentEvents)
          if (t.id == updated.id) updated else t,
      ]);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  /// Supprimer une tâche
  Future<void> deleteEvent(int id) async {
    try {
      await repository.deleteEvent(id);
      state = AsyncData(currentEvents.where((t) => t.id != id).toList());
    } on ApiException catch (e) {
      rethrow;
    }
  }

  /// Envoyer un fichier (optionnel)
  Future<void> uploadFileForEvent(int eventId, String filePath) async {
    try {
      await repository.uploadAttachment(eventId, filePath);
      // Tu peux déclencher une recharge ou non ici
    } on ApiException catch (e) {
      rethrow;
    }
  }
}
