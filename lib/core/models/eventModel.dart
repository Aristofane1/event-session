import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:event_session/core/models/userModel.dart';
import 'package:flutter/material.dart';

enum EventStatus {
  paid,
  completed,
  upcoming,
  cancelled;

  static EventStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return EventStatus.paid;
      case 'completed':
        return EventStatus.completed;
      case 'upcoming':
      case 'upcomming':
        return EventStatus.upcoming;
      case 'cancelled':
        return EventStatus.cancelled;
      default:
        return EventStatus.upcoming;
    }
  }

  String get displayName {
    switch (this) {
      case EventStatus.paid:
        return 'Paid';
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.upcoming:
        return 'Upcoming';
      case EventStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case EventStatus.paid:
        return const Color(0xFF5FA8EE);
      case EventStatus.completed:
        return const Color(0xFF459B73);
      case EventStatus.upcoming:
        return const Color(0xFF5FA8EE);
      case EventStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

class EventModel extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final String? eventDate;
  final String? eventTime;
  final String? type;
  final EventStatus status;
  final String? photo;
  final double? rate;
  final int? price;
  final bool? isWaitingList;
  final Address? address;
  final int? totalCurrentUser;
  final int? userGoal;
  final String? createdAt;
  final String? updatedAt;
  final int? userId;
  final List<int?>? users;

  const EventModel({
    this.id,
    this.name,
    this.description,
    this.eventDate,
    this.eventTime,
    this.type,
    this.status = EventStatus.upcoming,
    this.photo,
    this.rate,
    this.price,
    this.isWaitingList,
    this.address,
    this.totalCurrentUser,
    this.userGoal,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.users,
  });

  @override
  List<Object> get props => [id!];

  /// Retourne true si l'événement peut être annulé
  bool get canBeCancelled {
    return status == EventStatus.paid || status == EventStatus.upcoming;
  }

  /// Retourne true si l'événement est terminé
  bool get isCompleted {
    return status == EventStatus.completed;
  }

  /// Retourne true si l'événement est annulé
  bool get isCancelled {
    return status == EventStatus.cancelled;
  }

  bool get isPaid {
    return status == EventStatus.paid;
  }

  bool get isUpcoming {
    return status == EventStatus.upcoming;
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      eventDate: json['event_date'],
      eventTime: json['event_time'],
      type: json['type'],
      status: EventStatus.fromString(json['status']),
      photo: json['photo'],
      rate: double.tryParse("${json['rate']}") ?? 5,
      price: json['price'],
      isWaitingList: json['waiting_list'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      totalCurrentUser: json['total_current_user'],
      userGoal: json['user_goal'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      users: json['users'] != null && "${json['users']}".isNotEmpty
          ? List<int?>.from(
              jsonDecode(
                "${json['users']}",
              ).map((e) => e is int ? e : int.tryParse(e.toString())),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['event_date'] = eventDate;
    data['event_time'] = eventTime;
    data['type'] = type;
    data['status'] = status.name;
    data['photo'] = photo;
    data['rate'] = rate;
    data['price'] = price;
    data['waiting_list'] = isWaitingList;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['total_current_user'] = totalCurrentUser;
    data['user_goal'] = userGoal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['users'] = "";
    return data;
  }
}

class Address {
  String? name;
  double? longitude;
  double? latitude;

  Address({this.name, this.longitude, this.latitude});

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
