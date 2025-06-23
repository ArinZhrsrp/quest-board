// shared/quest_card.dart

import 'package:flutter/material.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/data/model/reward_model.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;

  const RewardCard({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.pinkAccent.shade100;

    final List<IconData> icons = [
      Icons.card_giftcard, // Gift
      Icons.diamond, // Diamond
      Icons.coffee, // Coffee
      Icons.shopping_bag, // Bag
      Icons.tv, // TV
      Icons.restaurant, // Food
      Icons.flight, // Plane
    ];

    // Fallback in case index is out of bounds
    final icon = reward.iconIndex < icons.length
        ? icons[reward.iconIndex]
        : Icons.card_giftcard;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 50),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(reward.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(reward.description),
                    const SizedBox(height: 8),
                    Row(children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: primaryColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(reward.status.label,
                          style: TextStyle(color: primaryColor)),
                    ]),
                  ],
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Column(
                children: [
                  Text('Cost: ${reward.pointsCost} pts',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (reward.status == RewardStatus.available)
                        _redeemButton(context),
                      const SizedBox(width: 12),
                      _deleteButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _redeemButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await RewardDatabaseHelper.instance.redeemReward(reward.id!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Reward marked as claimed.'),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_circle_outline,
            color: Colors.green, size: 20),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await RewardDatabaseHelper.instance.deleteReward(reward.id!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Reward deleted.'),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15), shape: BoxShape.circle),
        child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
      ),
    );
  }
}
