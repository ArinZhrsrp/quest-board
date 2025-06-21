// ---------------- Dashboard Page ----------------

import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/data/local/quest_helper.dart';
import 'package:task_game/data/model/quest_model.dart';
import 'package:task_game/data/model/reward_model.dart';
import 'package:task_game/quests/quest_list_preview.dart';
import 'package:task_game/rewards/reward_list_preview.dart';
import 'package:task_game/shared/stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color progressBarBackground = const Color(0xFFEDEEF2);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // Level & XP Progress Row
                LevelStats(
                    progressBarBackground: progressBarBackground,
                    primaryColor: primaryColor),
                const SizedBox(height: 20),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<Quest>>(
                        future: QuestDatabaseHelper.instance
                            .fetchQuestsByStatus(QuestStatus.active),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const StatsCard(
                              title: 'Active Quests',
                              value: '...',
                              icon: Icons.list_alt_rounded,
                            );
                          }

                          final count = snapshot.data?.length ?? 0;

                          return StatsCard(
                            title: 'Active Quests',
                            value: '$count',
                            icon: Icons.list_alt_rounded,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        title: 'Day Streak',
                        value: '0',
                        icon: Icons.local_fire_department_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        title: 'Achievements',
                        value: '0',
                        icon: Icons.emoji_events_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Active Quests Header
                SectionHeader(
                  title: 'Active Quests',
                  onTap: () {
                    Navigator.pushNamed(context, '/createQuest');
                  },
                ),

                // Active Quests List
                QuestListPreview(status: QuestStatus.active),
                const SizedBox(height: 32),

                // Active Rewards Header
                SectionHeader(
                  title: 'Available Rewards',
                  onTap: () {},
                  isQuest: false,
                ),

                // Available Rewards List
                RewardListPreview(
                  status: RewardStatus.available,
                ),

                // Gap from bottom
                const SizedBox(height: 40),
              ],
            ),
          ),
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
                'Level 1',
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
                '0/1000 XP',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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

class CustomPoints extends StatelessWidget {
  const CustomPoints({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons
                .paid_outlined, // Placeholder icon for currency, can be replaced
            size: 18,
            color: Colors.blue,
          ),
          SizedBox(width: 4),
          Text(
            '0',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.onTap,
    this.isQuest = true,
  });

  final String title;
  final VoidCallback onTap;
  final bool isQuest;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.3),
        ),
        CustomButton(
          type: CustomButtonType.icon,
          title: 'New',
          iconData: Icons.add_circle_outline_rounded,
          onPressed: onTap,
          color: isQuest ? null : Colors.pinkAccent.shade100,
          overlayColor: isQuest ? null : Colors.pink.shade100,
        ),
      ],
    );
  }
}
