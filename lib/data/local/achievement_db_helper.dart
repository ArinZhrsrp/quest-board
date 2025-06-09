import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_game/data/model/achievement_model.dart';
import 'package:share_plus/share_plus.dart';

class AchievementDbHelper {
  static final AchievementDbHelper _instance = AchievementDbHelper._();
  static Database? _database;

  AchievementDbHelper._();

  factory AchievementDbHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'achievements.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE achievements(
        id INTEGER PRIMARY KEY,
        icon TEXT,
        title TEXT,
        description TEXT,
        unlocked INTEGER
      )
    ''');
  }

  Future<void> insertAchievement(AchievementModel achievement) async {
    final db = await database;
    await db.insert('achievements', achievement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AchievementModel>> getAllAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    return maps.map((map) => AchievementModel.fromMap(map)).toList();
  }

  Future<void> updateAchievement(AchievementModel achievement) async {
    final db = await database;
    await db.update(
      'achievements',
      achievement.toMap(),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  static Future<void> share() async {
    final databasePath = await getDatabasesPath();

    final path = '$databasePath/achievements.db';

    var file = ShareParams(files: [XFile(path)]);

    SharePlus.instance.share(file);
  }
}

IconData? getIconData(String iconName) {
  const iconMap = {
    'flag': Icons.flag,
    'military_tech': Icons.military_tech,
    'emoji_events': Icons.emoji_events,
    'star': Icons.star,
    'stars': Icons.stars,
    'show_chart': Icons.show_chart,
    'trending_up': Icons.trending_up,
    'timeline': Icons.timeline,
    'leaderboard': Icons.leaderboard,
    'whatshot': Icons.whatshot,
    'card_giftcard': Icons.card_giftcard,
    'redeem': Icons.redeem,
    'wallet_giftcard': Icons.wallet_giftcard,
    'volunteer_activism': Icons.volunteer_activism,
    'workspace_premium': Icons.workspace_premium,
    'attach_money': Icons.attach_money,
    'money': Icons.money,
    'savings': Icons.savings,
    'account_balance_wallet': Icons.account_balance_wallet,
    'wb_twilight': Icons.wb_twilight,
    'nights_stay': Icons.nights_stay,
    'speed': Icons.speed,
    'format_list_bulleted': Icons.format_list_bulleted,
    'check_circle': Icons.check_circle,
    'weekend': Icons.weekend,
    'calendar_view_week': Icons.calendar_view_week,
    'repeat': Icons.repeat,
    'loop': Icons.loop,
    'calendar_month': Icons.calendar_month,
    'self_improvement': Icons.self_improvement,
    'fitness_center': Icons.fitness_center,
    'local_drink': Icons.local_drink,
    'no_cell': Icons.no_cell,
    'wb_sunny': Icons.wb_sunny,
    'celebration': Icons.celebration,
    'festival': Icons.festival,
    'cake': Icons.cake,
    'calendar_today': Icons.calendar_today,
    'share': Icons.share,
    'group_add': Icons.group_add,
    'thumb_up': Icons.thumb_up,
    'forum': Icons.forum,
    'handshake': Icons.handshake,
    'refresh': Icons.refresh,
    'create': Icons.create,
    'image': Icons.image,
    'event_note': Icons.event_note,
    'emoji_events_outlined': Icons.emoji_events_outlined,
  };

  return iconMap[iconName];
}

Future<void> seedAchievements() async {
  final dbHelper = AchievementDbHelper();
  final existing = await dbHelper.getAllAchievements();

  if (existing.isEmpty) {
    final achievements = [
      AchievementModel(
          id: 1,
          icon: 'flag',
          title: 'Adventurer',
          description: 'Complete 5 tasks',
          unlocked: false),
      AchievementModel(
          id: 2,
          icon: 'military_tech',
          title: 'Hero',
          description: 'Complete 20 tasks',
          unlocked: false),
      AchievementModel(
          id: 3,
          icon: 'emoji_events',
          title: 'Task Master',
          description: 'Complete 50 tasks',
          unlocked: false),
      AchievementModel(
          id: 4,
          icon: 'star',
          title: 'Legend',
          description: 'Complete 100 tasks',
          unlocked: false),
      AchievementModel(
          id: 5,
          icon: 'stars',
          title: 'Machine',
          description: 'Complete 200 tasks',
          unlocked: false),
      // AchievementModel(
      //     id: 6,
      //     icon: 'show_chart',
      //     title: 'Consistent',
      //     description: 'Maintain a 3-day streak',
      //     unlocked: false),
      // AchievementModel(
      //     id: 7,
      //     icon: 'trending_up',
      //     title: 'Unstoppable',
      //     description: 'Maintain a 7-day streak',
      //     unlocked: false),
      // AchievementModel(
      //     id: 8,
      //     icon: 'timeline',
      //     title: 'Dedicated',
      //     description: 'Maintain a 14-day streak',
      //     unlocked: false),
      // AchievementModel(
      //     id: 9,
      //     icon: 'leaderboard',
      //     title: 'Streak King',
      //     description: 'Maintain a 30-day streak',
      //     unlocked: false),
      // AchievementModel(
      //     id: 10,
      //     icon: 'whatshot',
      //     title: 'Iron Will',
      //     description: 'Maintain a 60-day streak',
      //     unlocked: false),
      // AchievementModel(
      //     id: 11,
      //     icon: 'card_giftcard',
      //     title: 'First Treasure',
      //     description: 'Claim your first reward',
      //     unlocked: false),
      // AchievementModel(
      //     id: 12,
      //     icon: 'redeem',
      //     title: 'Collector',
      //     description: 'Claim 5 rewards',
      //     unlocked: false),
      // AchievementModel(
      //     id: 13,
      //     icon: 'wallet_giftcard',
      //     title: 'Treasure Hunter',
      //     description: 'Claim 10 rewards',
      //     unlocked: false),
      // AchievementModel(
      //     id: 14,
      //     icon: 'volunteer_activism',
      //     title: 'Riches Await',
      //     description: 'Claim 20 rewards',
      //     unlocked: false),
      // AchievementModel(
      //     id: 15,
      //     icon: 'workspace_premium',
      //     title: 'Reward Royalty',
      //     description: 'Claim 50 rewards',
      //     unlocked: false),
      // AchievementModel(
      //     id: 16,
      //     icon: 'attach_money',
      //     title: 'Wealthy',
      //     description: 'Earn 1000 points',
      //     unlocked: false),
      // AchievementModel(
      //     id: 17,
      //     icon: 'money',
      //     title: 'Prosperous',
      //     description: 'Earn 5000 points',
      //     unlocked: false),
      // AchievementModel(
      //     id: 18,
      //     icon: 'savings',
      //     title: 'Tycoon',
      //     description: 'Earn 10,000 points',
      //     unlocked: false),
      // AchievementModel(
      //     id: 19,
      //     icon: 'account_balance_wallet',
      //     title: 'Fortune Builder',
      //     description: 'Earn 20,000 points',
      //     unlocked: false),
      // AchievementModel(
      //     id: 20,
      //     icon: 'trending_up',
      //     title: 'Pointzilla',
      //     description: 'Earn 50,000 points',
      //     unlocked: false),
      // AchievementModel(
      //     id: 21,
      //     icon: 'wb_twilight',
      //     title: 'Early Bird',
      //     description: 'Complete a task before 8 AM',
      //     unlocked: false),
      // AchievementModel(
      //     id: 22,
      //     icon: 'nights_stay',
      //     title: 'Night Owl',
      //     description: 'Complete a task after 10 PM',
      //     unlocked: false),
      // AchievementModel(
      //     id: 23,
      //     icon: 'speed',
      //     title: 'Speedster',
      //     description: 'Complete 3 tasks in one hour',
      //     unlocked: false),
      // AchievementModel(
      //     id: 24,
      //     icon: 'format_list_bulleted',
      //     title: 'Multitasker',
      //     description: 'Complete 5 tasks in one day',
      //     unlocked: false),
      // AchievementModel(
      //     id: 25,
      //     icon: 'check_circle',
      //     title: 'Closer',
      //     description: 'Complete all tasks for the day',
      //     unlocked: false),
      // AchievementModel(
      //     id: 26,
      //     icon: 'weekend',
      //     title: 'Weekend Warrior',
      //     description: 'Complete tasks every Saturday & Sunday',
      //     unlocked: false),
      // AchievementModel(
      //     id: 27,
      //     icon: 'calendar_view_week',
      //     title: 'Weekly Winner',
      //     description: 'Complete tasks for all 7 days in a week',
      //     unlocked: false),
      // AchievementModel(
      //     id: 28,
      //     icon: 'repeat',
      //     title: 'Routine Maker',
      //     description: 'Complete tasks for 4 consecutive weeks',
      //     unlocked: false),
      // AchievementModel(
      //     id: 29,
      //     icon: 'loop',
      //     title: 'Habitual',
      //     description: 'Complete tasks every day for a month',
      //     unlocked: false),
      // AchievementModel(
      //     id: 30,
      //     icon: 'calendar_month',
      //     title: 'Loyal User',
      //     description: 'Open the app daily for 30 days',
      //     unlocked: false),
      // AchievementModel(
      //     id: 31,
      //     icon: 'self_improvement',
      //     title: 'Mindful',
      //     description: 'Complete a meditation/wellness task',
      //     unlocked: false),
      // AchievementModel(
      //     id: 32,
      //     icon: 'fitness_center',
      //     title: 'Fitness First',
      //     description: 'Log a fitness-related task',
      //     unlocked: false),
      // AchievementModel(
      //     id: 33,
      //     icon: 'local_drink',
      //     title: 'Hydrated',
      //     description: 'Mark "drink water" task 7 days in a row',
      //     unlocked: false),
      // AchievementModel(
      //     id: 34,
      //     icon: 'no_cell',
      //     title: 'Digital Detox',
      //     description: 'Stay off social media for a day',
      //     unlocked: false),
      // AchievementModel(
      //     id: 35,
      //     icon: 'wb_sunny',
      //     title: 'Early Riser',
      //     description: 'Wake up before 7 AM for 5 days',
      //     unlocked: false),
      // AchievementModel(
      //     id: 36,
      //     icon: 'celebration',
      //     title: 'New Year, New Me',
      //     description: 'Complete a task on Jan 1',
      //     unlocked: false),
      // AchievementModel(
      //     id: 37,
      //     icon: 'festival',
      //     title: 'Festive Hustle',
      //     description: 'Complete a task on a public holiday',
      //     unlocked: false),
      // AchievementModel(
      //     id: 38,
      //     icon: 'cake',
      //     title: 'Birthday Bonus',
      //     description: 'Complete a task on your birthday',
      //     unlocked: false),
      // AchievementModel(
      //     id: 39,
      //     icon: 'weekend',
      //     title: 'Weekend Hustler',
      //     description: 'Complete tasks every weekend for a month',
      //     unlocked: false),
      // AchievementModel(
      //     id: 40,
      //     icon: 'calendar_today',
      //     title: 'Month Starter',
      //     description: 'Complete a task on the 1st of any month',
      //     unlocked: false),
      // AchievementModel(
      //     id: 41,
      //     icon: 'share',
      //     title: 'Sharer',
      //     description: 'Share the app with 1 friend',
      //     unlocked: false),
      // AchievementModel(
      //     id: 42,
      //     icon: 'group_add',
      //     title: 'Squad Goals',
      //     description: 'Invite 5 friends',
      //     unlocked: false),
      // AchievementModel(
      //     id: 43,
      //     icon: 'thumb_up',
      //     title: 'Motivator',
      //     description: 'Encourage a friend to complete a task',
      //     unlocked: false),
      // AchievementModel(
      //     id: 44,
      //     icon: 'forum',
      //     title: 'Community Helper',
      //     description: 'Comment or post in app forum',
      //     unlocked: false),
      // AchievementModel(
      //     id: 45,
      //     icon: 'handshake',
      //     title: 'Buddy System',
      //     description: 'Complete a task with a friend',
      //     unlocked: false),
      // AchievementModel(
      //     id: 46,
      //     icon: 'refresh',
      //     title: 'Streak Saver',
      //     description: 'Resume your streak after missing one day',
      //     unlocked: false),
      // AchievementModel(
      //     id: 47,
      //     icon: 'create',
      //     title: 'Task Architect',
      //     description: 'Create 20 custom tasks',
      //     unlocked: false),
      // AchievementModel(
      //     id: 48,
      //     icon: 'image',
      //     title: 'Visual Tracker',
      //     description: 'Add 10 images or notes to tasks',
      //     unlocked: false),
      // AchievementModel(
      //     id: 49,
      //     icon: 'event_note',
      //     title: 'Planner Pro',
      //     description: 'Plan a full week in advance',
      //     unlocked: false),
      // AchievementModel(
      //     id: 50,
      //     icon: 'emoji_events_outlined',
      //     title: 'Completionist',
      //     description: 'Complete all types of achievements',
      //     unlocked: false),
    ];

    for (var achievement in achievements) {
      await dbHelper.insertAchievement(achievement);
    }
  }
}
