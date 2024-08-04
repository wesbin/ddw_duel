import 'package:ddw_duel/db/table_abstract.dart';
import 'package:ddw_duel/db/enum/team_enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Team implements TableAbstract {
  final int? teamId;
  String name;
  final int eventId;
  double point;
  int isForfeited;

  Team(
      {this.teamId,
      required this.eventId,
      this.point = 0.0,
      required this.name,
      this.isForfeited = 0});

  @override
  Map<String, dynamic> toMap() {
    return {
      TeamEnum.name.label: name,
      TeamEnum.eventId.label: eventId,
      TeamEnum.point.label: point,
      TeamEnum.isForfeited.label: isForfeited
    };
  }

  static Future<void> initTable(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE ${TeamEnum.tableName.label}(
        ${TeamEnum.id.label} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TeamEnum.name.label} TEXT,
        ${TeamEnum.eventId.label} INTEGER,
        ${TeamEnum.point.label} REAL,
        ${TeamEnum.isForfeited.label} INTEGER
      )
    ''');
  }
}
