import 'dart:convert';

import 'package:event_session/core/models/eventModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('EventModel - fromJson', () {
    test('doit parser un JSON complet', () {
      final json = {
        'id': 1,
        'name': 'Flutter Conf',
        'description': 'Learn Flutter',
        'event_date': '2025-01-01',
        'event_time': '10:00',
        'type': 'Meetup',
        'status': 'paid',
        'photo': 'https://image.com',
        'rate': '4.5',
        'price': 0,
        'waiting_list': true,
        'address': {'name': 'Epitech', 'longitude': 2.35, 'latitude': 48.85},
        'total_current_user': 10,
        'user_goal': 20,
        'created_at': '2025-01-01T10:00:00Z',
        'updated_at': '2025-01-01T11:00:00Z',
        'user_id': 42,
        'users': jsonEncode([1, 2, 3]),
      };

      final event = EventModel.fromJson(json);

      expect(event.id, 1);
      expect(event.name, 'Flutter Conf');
      expect(event.status, EventStatus.paid);
      expect(event.rate, 4.5);
      expect(event.isWaitingList, true);
      expect(event.address!.name, 'Epitech');
      expect(event.users, [1, 2, 3]);
    });

    test('doit retourner une valeur par défaut en cas de status inconnu', () {
      final json = {'id': 2, 'status': 'unknown'};

      final event = EventModel.fromJson(json);
      expect(event.status, EventStatus.upcoming);
    });

    test('doit retourner null si users est vide', () {
      final json = {'id': 3, 'users': ''};

      final event = EventModel.fromJson(json);
      expect(event.users, null);
    });
  });

  group('EventModel - toJson', () {
    test('doit sérialiser l’objet en JSON correctement', () {
      EventModel event = EventModel(
        id: 1,
        name: 'Test Event',
        description: 'Desc',
        eventDate: '2025-08-01',
        eventTime: '18:00',
        type: 'Workshop',
        status: EventStatus.completed,
        photo:
            'https://media.istockphoto.com/id/1330424071/fr/photo/grand-groupe-de-personnes-lors-dune-f%C3%AAte-de-concert.jpg?s=612x612&w=0&k=20&c=RwrufrKpTVQzlNFzPsj5INPPMLe9cmatOIiWr1MmFUY=',
        rate: 4.0,
        price: 100,
        isWaitingList: false,
        address: Address(name: 'Lieu', latitude: 1.2, longitude: 3.4),
        totalCurrentUser: 15,
        userGoal: 30,
        createdAt: 'now',
        updatedAt: 'later',
        userId: 5,
        users: [1, 2],
      );

      final json = event.toJson();

      expect(json['status'], 'completed');
      expect(json['name'], 'Test Event');
      expect(json['address']['name'], 'Lieu');
    });
  });

  group('EventModel - logique métier', () {
    test('canBeCancelled retourne true si paid ou upcoming', () {
      const paidEvent = EventModel(status: EventStatus.paid);
      const upcomingEvent = EventModel(status: EventStatus.upcoming);
      const completedEvent = EventModel(status: EventStatus.completed);

      expect(paidEvent.canBeCancelled, true);
      expect(upcomingEvent.canBeCancelled, true);
      expect(completedEvent.canBeCancelled, false);
    });

    test('isCompleted retourne true uniquement si status est completed', () {
      const event = EventModel(status: EventStatus.completed);
      expect(event.isCompleted, true);
    });

    test('isCancelled retourne true uniquement si annulé', () {
      const event = EventModel(status: EventStatus.cancelled);
      expect(event.isCancelled, true);
    });

    test('isPaid retourne true uniquement si payé', () {
      const event = EventModel(status: EventStatus.paid);
      expect(event.isPaid, true);
    });
  });

  group('EventStatus', () {
    test('fromString gère les cas valides et invalides', () {
      expect(EventStatus.fromString('paid'), EventStatus.paid);
      expect(EventStatus.fromString('upcomming'), EventStatus.upcoming);
      expect(EventStatus.fromString('cancelled'), EventStatus.cancelled);
      expect(EventStatus.fromString(null), EventStatus.upcoming);
      expect(EventStatus.fromString('unknown'), EventStatus.upcoming);
    });

    test('displayName est correct pour chaque status', () {
      expect(EventStatus.paid.displayName, 'Paid');
      expect(EventStatus.completed.displayName, 'Completed');
    });

    test('color retourne une couleur pour chaque status', () {
      expect(EventStatus.cancelled.color, const Color(0xFFEF4444));
    });
  });

  group('Address', () {
    test('fromJson et toJson fonctionnent correctement', () {
      final address = Address.fromJson({
        'name': 'Lieu',
        'latitude': 1.23,
        'longitude': 4.56,
      });

      final json = address.toJson();

      expect(json['name'], 'Lieu');
      expect(json['latitude'], 1.23);
      expect(json['longitude'], 4.56);
    });
  });
}
