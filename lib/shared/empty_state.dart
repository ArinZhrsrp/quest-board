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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isQuest ? Icons.list_alt_rounded : Icons.north_east_rounded,
          size: 48,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 18),
        Text(isQuest ? 'No Quests' : 'No Rewards ',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          isQuest
              ? 'Start your journey by creating your first quest.'
              : 'Create rewards to motivate yourself.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey[600]),
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
