import 'package:ddw_duel/db/domain/event.dart';
import 'package:ddw_duel/db/enum/event_enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database_helper.dart';

class EventRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> saveEvent(Event event) async {
    Database db = await dbHelper.database;
    if (event.eventId != null) {
      await db.update(
        EventEnum.tableName.label,
        event.toMap(),
        where: "${EventEnum.id.label} = ?",
        whereArgs: [event.eventId],
      );
      return event.eventId!;
    } else {
      return await db.insert(
        EventEnum.tableName.label,
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Event>> findEvents() async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(EventEnum.tableName.label);
    return List.generate(maps.length, (i) {
      return _makeEvent(maps[i]);
    });
  }

  Future<Event?> findEventsById(int eventId) async {
    Database db = await dbHelper.database;
    final List<Map<String, dynamic>> maps =
    await db.query(EventEnum.tableName.label, where: '${EventEnum.id.label} = ?', whereArgs: [eventId]);
    if (maps.isNotEmpty) {
      return _makeEvent(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateEvent(Event event) async {
    Database db = await dbHelper.database;
    await db.update(
      EventEnum.tableName.label,
      event.toMap(),
      where: "${EventEnum.id.label} = ?",
      whereArgs: [event.eventId],
    );
  }

  Future<void> deleteEvent(int id) async {
    Database db = await dbHelper.database;
    await db.delete(
      EventEnum.tableName.label,
      where: "${EventEnum.id.label} = ?",
      whereArgs: [id],
    );
  }

  Event _makeEvent(Map<String, dynamic> map) {
    return Event(
      eventId: map[EventEnum.id.label],
      name: map[EventEnum.name.label],
      description: map[EventEnum.description.label],
      currentRound: map[EventEnum.currentRound.label],
      endRound: map[EventEnum.endRound.label]
    );
  }
}
