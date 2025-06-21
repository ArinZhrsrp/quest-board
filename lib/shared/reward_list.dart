import 'package:flutter/material.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/data/model/reward_model.dart';
import 'package:task_game/shared/empty_state.dart';
import 'package:task_game/shared/reward_card.dart';

class RewardList extends StatelessWidget {
  const RewardList({super.key, this.status});

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
          return const Center(child: EmptyStateCard());
        }

        final quests = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: quests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return RewardCard(reward: quests[index]);
          },
        );
      },
    );
  }
}
