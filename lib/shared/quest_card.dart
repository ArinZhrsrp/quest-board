// shared/quest_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_game/data/model/quest_model.dart';
import 'package:task_game/data/local/quest_helper.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;

  const QuestCard({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(quest.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${quest.pointsReward} pts',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(quest.description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(quest.status.label,
                      style: TextStyle(color: primaryColor)),
                ]),
                if (quest.deadlineDateTime != null)
                  Row(children: [
                    const Icon(Icons.alarm, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd-MM-yyyy h:mm a').format(
                          DateTime.parse(quest.deadlineDateTime.toString())
                              .toLocal()),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ]),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton(context, Icons.check_circle_outline, Colors.green,
                    QuestStatus.completed),
                const SizedBox(width: 12),
                _actionButton(context, Icons.error_outline, Colors.orange,
                    QuestStatus.failed),
                const SizedBox(width: 12),
                _deleteButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      BuildContext context, IconData icon, Color color, QuestStatus newStatus) {
    return GestureDetector(
      onTap: () async {
        await QuestDatabaseHelper.instance
            .updateQuest(quest.copyWith(status: newStatus));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Quest marked as ${newStatus.label}.'),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withOpacity(0.15), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await QuestDatabaseHelper.instance.deleteQuest(quest.id!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Quest deleted.'),
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
