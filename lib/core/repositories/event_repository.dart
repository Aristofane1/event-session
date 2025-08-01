import '../models/eventModel.dart';
import '../../services/api_service.dart';
import '../../config/exceptions/api_exceptions.dart';

class EventRepository {
  final ApiService api;

  EventRepository(this.api);

  // Récupérer une liste paginée de tâches
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await api.get('/events.json');

      return (response as Map).values
          .map((e) => EventModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Récupérer une liste paginée de tâches
  Future<List<EventModel>> getMyEvents() async {
    try {
      final response = await api.get('/my-events.json');

      return (response as Map).values
          .map((e) => EventModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Créer une tâche
  Future<dynamic> createEvent(EventModel event) async {
    try {
      Map<String, dynamic> newEvent = event.toJson();
      newEvent["status"] = "paid";
      final response = await api.post('/my-events.json', newEvent);
      return response;
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Mettre à jour une tâche
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final response = await api.put('', event.toJson());
      return EventModel.fromJson(response);
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Supprimer une tâche
  Future<void> deleteEvent(int id) async {
    try {
      await api.delete('');
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // (Optionnel) Envoyer un fichier associé à une tâche
  Future<void> uploadAttachment(int eventId, String filePath) async {
    try {
      await api.uploadFile('/events/$eventId/attachment', 'file', filePath);
    } on ApiException catch (e) {
      rethrow;
    }
  }
}
