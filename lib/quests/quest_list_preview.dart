import 'package:flutter/material.dart';
import 'package:task_game/data/local/quest_helper.dart';
import 'package:task_game/data/model/quest_model.dart';
import 'package:task_game/main_screen.dart';
import 'package:task_game/shared/empty_state.dart';
import 'package:task_game/shared/quest_card.dart';

class QuestListPreview extends StatelessWidget {
  const QuestListPreview({super.key, this.status});

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
          return const EmptyStateCard();
        }

        final quests = snapshot.data!;
        final showMore = quests.length > 3;
        final displayQuests = showMore ? quests.sublist(0, 3) : quests;

        return Column(
          children: [
            ...displayQuests.map((quest) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuestCard(quest: quest), // <-- Reuse your card builder
                )),
            if (showMore)
              TextButton(
                onPressed: () {
                  final mainState =
                      context.findAncestorStateOfType<MainScreenState>();
                  if (mainState != null) {
                    mainState.questTabIndex = 1; // set active
                    MainScreen.selectedTabNotifier.value = 1;
                  }
                },
                child: Text("View More (${quests.length})"),
              ),
          ],
        );
      },
    );
  }
}
