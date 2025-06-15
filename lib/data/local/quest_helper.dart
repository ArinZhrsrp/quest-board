import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_game/data/model/quest_model.dart';

class QuestDatabaseHelper {
  static final QuestDatabaseHelper instance = QuestDatabaseHelper._init();

  static Database? _database;

  QuestDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quests.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE quests (
        id $idType,
        title $textType,
        description $textType,
        pointsReward $integerType,
        deadlineDateTime TEXT,
        status TEXT NOT NULL
      )
    ''');
  }

  /// Insert Quest into DB
  Future<int> createQuest(Quest quest) async {
    final db = await instance.database;
    final id = await db.insert('quests', quest.toMap());

    return id;
  }

  /// Fetch all quests, auto-updating status of overdue active quests to failed
  Future<List<Quest>> fetchAllQuests() async {
    final db = await instance.database;

    // Update overdue active quests to failed
    await updateOverdueQuestsStatus();

    final result = await db.query('quests', orderBy: 'id DESC');
    return result.map((json) => Quest.fromMap(json)).toList();
  }

  /// Fetch quests by specific status (e.g., active, completed, failed)
  /// final activeQuests = await QuestDatabaseHelper.instance.fetchQuestsByStatus(QuestStatus.active);
  /// final completedQuests = await QuestDatabaseHelper.instance.fetchQuestsByStatus(QuestStatus.completed);
  /// final failedQuests = await QuestDatabaseHelper.instance.fetchQuestsByStatus(QuestStatus.failed);
  ///
  /// Future<List<Quest>> fetchActiveQuests() => fetchQuestsByStatus(QuestStatus.active);
  /// Future<List<Quest>> fetchCompletedQuests() =>
  ///     fetchQuestsByStatus(QuestStatus.completed);
  /// Future<List<Quest>> fetchFailedQuests() =>
  ///     fetchQuestsByStatus(QuestStatus.failed);
  Future<List<Quest>> fetchQuestsByStatus(QuestStatus status) async {
    final db = await instance.database;

    final result = await db.query(
      'quests',
      where: 'status = ?',
      whereArgs: [status.name],
      orderBy: 'id DESC',
    );

    return result.map((json) => Quest.fromMap(json)).toList();
  }

  /// Update a quest
  Future<int> updateQuest(Quest quest) async {
    final db = await instance.database;
    return db.update(
      'quests',
      quest.toMap(),
      where: 'id = ?',
      whereArgs: [quest.id],
    );
  }

  /// Delete a quest by id
  Future<int> deleteQuest(int id) async {
    final db = await instance.database;
    return db.delete(
      'quests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Set status = failed for all active quests whose deadline has passed
  Future<void> updateOverdueQuestsStatus() async {
    final db = await instance.database;
    final nowISO = DateTime.now().toIso8601String();

    await db.rawUpdate('''
      UPDATE quests
      SET status = ?
      WHERE deadlineDateTime IS NOT NULL AND deadlineDateTime < ? AND status = ?
    ''', [QuestStatus.failed.name, nowISO, QuestStatus.active.name]);
  }

  // SHARE DB FILE
  Future<void> shareQuestsDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'quests.db');
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Database file does not exist.');
    }

    // Share the copied file
    await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Here is my Quest DB!'));
  }

  /// Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
