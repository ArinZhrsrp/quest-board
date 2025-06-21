import 'package:flutter/material.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/data/model/reward_model.dart';
import 'package:task_game/main_screen.dart';
import 'package:task_game/shared/empty_state.dart';
import 'package:task_game/shared/reward_card.dart';

class RewardListPreview extends StatelessWidget {
  const RewardListPreview({super.key, this.status});

  final RewardStatus? status;

  @override
  Widget build(BuildContext context) {
    Future<List<Reward>> future = status == null
        ? RewardDatabaseHelper.instance.fetchAllRewards()
        : RewardDatabaseHelper.instance.fetchRewardsByStatus(status!);

    return FutureBuilder<List<Reward>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyStateCard();
        }

        final rewards = snapshot.data!;
        final showMore = rewards.length > 3;
        final displayRewards = showMore ? rewards.sublist(0, 3) : rewards;

        return Column(
          children: [
            ...displayRewards.map((reward) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  // child: SizedBox(),
                  child:
                      RewardCard(reward: reward), // <-- Reuse your card builder
                )),
            if (showMore)
              TextButton(
                onPressed: () {
                  final mainState =
                      context.findAncestorStateOfType<MainScreenState>();
                  if (mainState != null) {
                    mainState.questTabIndex = 2; // set active
                    MainScreen.selectedTabNotifier.value = 1;
                  }
                },
                child: Text("View More (${rewards.length})"),
              ),
          ],
        );
      },
    );
  }
}
