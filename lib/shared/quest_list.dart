import 'package:flutter/material.dart';
import 'package:task_game/data/local/quest_helper.dart';
import 'package:task_game/data/model/quest_model.dart';
import 'package:task_game/shared/empty_state.dart';
import 'package:task_game/shared/quest_card.dart';

class QuestList extends StatelessWidget {
  const QuestList({super.key, this.status});

  final QuestStatus? status;

  @override
  Widget build(BuildContext context) {
    Future<List<Quest>> future = status == null
        ? QuestDatabaseHelper.instance.fetchAllQuests()
        : QuestDatabaseHelper.instance.fetchQuestsByStatus(status!);

    return FutureBuilder<List<Quest>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: EmptyStateCard());
        }

        final quests = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: quests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return QuestCard(quest: quests[index]);
          },
        );
      },
    );
  }
}
