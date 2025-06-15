// ---------------- Quests Page ----------------

import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/data/local/quest_helper.dart';
import 'package:task_game/data/model/quest_model.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<Tab> _tabs = [
    Tab(text: 'All'),
    Tab(text: 'Active'),
    Tab(text: 'Completed'),
    Tab(text: 'Failed'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCreateQuestPressed() {
    Navigator.pushNamed(context, '/createQuest');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey[500],
              indicatorColor: primaryColor,
              indicatorWeight: 2,
              tabs: _tabs,
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                _buildQuestList(null), // All
                _buildQuestList(QuestStatus.active),
                _buildQuestList(QuestStatus.completed),
                _buildQuestList(QuestStatus.failed),
              ]),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: _onCreateQuestPressed,
            backgroundColor: primaryColor,
            elevation: 0,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestList(QuestStatus? status) {
    Future<List<Quest>> future = status == null
        ? QuestDatabaseHelper.instance.fetchAllQuests()
        : QuestDatabaseHelper.instance.fetchQuestsByStatus(status);

    return FutureBuilder<List<Quest>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.list_alt_rounded, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 18),
                Text('No Quests',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "You don't have any quests in this category.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  type: CustomButtonType.coloredIcon,
                  iconData: Icons.add_circle_outline_rounded,
                  title: 'Create Quest',
                  onPressed: _onCreateQuestPressed,
                ),
              ],
            ),
          );
        }

        final quests = snapshot.data!;

        return ListView.separated(
          padding: EdgeInsets.all(12),
          itemCount: quests.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final quest = quests[index];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quest.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${quest.pointsReward} pts",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Description
                    Text(quest.description),
                    SizedBox(height: 8),

                    // Status & Due Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status: ${quest.status.label}"),
                        if (quest.deadlineDateTime != null)
                          Text(
                            "Due: ${DateTime.parse(quest.deadlineDateTime.toString()).toLocal().toString().split(' ').first}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await QuestDatabaseHelper.instance.updateQuest(
                              quest.copyWith(status: QuestStatus.completed),
                            );
                            setState(() {});
                          },
                          child: Text("Complete"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () async {
                            await QuestDatabaseHelper.instance.updateQuest(
                              quest.copyWith(status: QuestStatus.failed),
                            );
                            setState(() {});
                          },
                          child: Text("Abandon"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            await QuestDatabaseHelper.instance
                                .deleteQuest(quest.id!);
                            setState(() {});
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
