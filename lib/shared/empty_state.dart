import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    this.isQuest = true,
    this.onTap,
  });

  final bool isQuest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.north_east_rounded,
          size: 32,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 12),
        Text(
          isQuest ? 'No Active Quests' : 'No Rewards Yet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isQuest
              ? 'Start your journey by creating your first quest.'
              : 'Create rewards to motivate yourself.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        CustomButton(
          type: CustomButtonType.coloredIcon,
          iconData: Icons.add_circle_outline_rounded,
          title: isQuest ? 'Create Quest' : 'Create Reward',
          onPressed: () => isQuest
              ? Navigator.pushNamed(context, '/createQuest')
              : Navigator.pushNamed(context, '/createRewards'),
          color: isQuest ? null : Colors.pinkAccent.shade100,
          overlayColor: isQuest ? null : Colors.pink.shade100,
        ),
      ],
    );
  }
}
