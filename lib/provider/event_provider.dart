import 'package:ddw_duel/domain/event/domain/event.dart';
import 'package:ddw_duel/domain/event/repository/event_repository.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  final EventRepository eventRepo = EventRepository();

  List<Event> _events = [];

  List<Event> get events => _events;

  Future<void> fetchEvent() async {
    // fixme
    await Future.delayed(Duration(seconds: 1));
    List<Event> events = await eventRepo.findEvents();
    _events = events;
    notifyListeners();
  }
}