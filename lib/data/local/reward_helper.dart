import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_game/data/model/reward_model.dart';

class RewardDatabaseHelper {
  static final RewardDatabaseHelper instance = RewardDatabaseHelper._init();

  static Database? _database;

  RewardDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rewards.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rewards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        pointsCost INTEGER NOT NULL,
        iconIndex INTEGER NOT NULL,
        status INTEGER NOT NULL
      )
    ''');
  }

  Future<int> createReward(Reward reward) async {
    final db = await instance.database;
    return await db.insert('rewards', reward.toMap());
  }

  Future<List<Reward>> fetchAllRewards() async {
    final db = await instance.database;
    final result = await db.query('rewards', orderBy: 'id DESC');
    return result.map((map) => Reward.fromMap(map)).toList();
  }

  Future<int> updateReward(Reward reward) async {
    final db = await instance.database;
    return await db.update(
      'rewards',
      reward.toMap(),
      where: 'id = ?',
      whereArgs: [reward.id],
    );
  }

  Future<int> redeemReward(int id) async {
    final db = await instance.database;
    return await db.update(
      'rewards',
      {'status': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReward(int id) async {
    final db = await instance.database;
    return await db.delete(
      'rewards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllRewards() async {
    final db = await instance.database;
    await db.delete('rewards');
  }

  Future<List<Reward>> fetchUnredeemedRewards() async {
    final db = await instance.database;
    final result = await db.query('rewards', where: 'status = 0');
    return result.map((map) => Reward.fromMap(map)).toList();
  }

  // SHARE DB FILE
  Future<void> shareRewardsDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'rewards.db');
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Database file does not exist.');
    }

    // Share the copied file
    await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Here is my Reward DB!'));
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
