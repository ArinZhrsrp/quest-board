// =================== Profile Page ===================

import 'package:flutter/material.dart';
import 'package:task_game/data/local/achievement_db_helper.dart';
import 'package:task_game/data/model/achievement_model.dart';
import 'package:task_game/home/home_view.dart';
import 'package:task_game/shared/stats_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final Color progressBarBackground = const Color(0xFFEDEEF2);

    final dbHelper = AchievementDbHelper();

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(onPressed: () {
        AchievementDbHelper.share();
      }),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top card with level, XP and day streak
            LevelStats(
                progressBarBackground: progressBarBackground,
                primaryColor: primaryColor),

            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Completed',
                    value: '0',
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.lightGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Achievements',
                    value: '0',
                    icon: Icons.emoji_events_rounded,
                    iconColor: Colors.lightBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Rewards',
                    value: '0',
                    icon: Icons.card_giftcard_rounded,
                    iconColor: Colors.pink,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Achievements (0/8)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 16),

            FutureBuilder<List<AchievementModel>>(
                future: dbHelper.getAllAchievements(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Failed to load achievements.'));
                  }

                  final achievements = (snapshot.data ?? []).take(8).toList();

                  return Column(
                      children: achievements.map((achievement) {
                    return _AchievementTile(
                      title: achievement.title,
                      description: achievement.description,
                      locked: !achievement.unlocked,
                      // locked: false,
                      icon: getIconData(achievement.icon) ??
                          Icons.emoji_events_outlined,
                    );
                  }).toList());
                }),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final String title;
  final String description;
  final bool locked;
  final IconData icon;

  const _AchievementTile({
    required this.title,
    required this.description,
    required this.locked,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: locked ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: locked ? Colors.white : Colors.black)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            locked ? Icons.lock_outline_rounded : icon,
            color: locked ? Colors.grey[600] : Colors.amber,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight:
                            locked ? FontWeight.normal : FontWeight.bold,
                        fontSize: locked ? 14 : 16,
                        color: locked ? Colors.grey : Colors.black)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                      fontSize: 12,
                      color: locked ? Colors.grey[600] : Colors.grey[800],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LevelStats extends StatelessWidget {
  const LevelStats({
    super.key,
    required this.progressBarBackground,
    required this.primaryColor,
  });

  final Color progressBarBackground;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Level Badge
        Container(
          width: 52,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.pink.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Lvl 1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Level 1 Adventurer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0, // 0/1000 XP
                  backgroundColor: progressBarBackground,
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '0/1000 XP to Level 2',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.whatshot,
                    color: Colors.amber,
                    size: 15,
                  ),
                  Text(
                    '0 Day Streak',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Currency Container
        CustomPoints(),
      ],
    );
  }
}
