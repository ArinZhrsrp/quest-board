import 'package:flutter/material.dart';
import 'package:task_game/data/local/quest_helper.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/main_screen.dart';
import 'package:task_game/quests/create_quest_view.dart';
import 'package:task_game/rewards/create_reward_view.dart';

Future<void> main() async {
  runApp(const MyApp());
  // await seedAchievements();

  await QuestDatabaseHelper.instance.fetchAllQuests();
  await RewardDatabaseHelper.instance.fetchAllRewards();

  final allQuests = await QuestDatabaseHelper.instance.fetchAllQuests();
  print('All Quests: $allQuests');

  final allRewards = await RewardDatabaseHelper.instance.fetchAllRewards();
  print('All Rewards: $allRewards');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Game',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        fontFamily: 'SF Pro Text',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/createQuest': (context) =>
            const CreateQuestsView(), // Add the route here
        '/createRewards': (context) =>
            const CreateRewardView(), // Add the route here
      },
    );
  }
}
