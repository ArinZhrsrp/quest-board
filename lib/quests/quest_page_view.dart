import 'package:flutter/material.dart';
import 'package:task_game/data/model/quest_model.dart';
import 'package:task_game/shared/quest_list.dart';

class QuestsPage extends StatefulWidget {
  final int initialTabIndex;
  const QuestsPage({super.key, this.initialTabIndex = 0});

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
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCreateQuestPressed() {
    Navigator.pushNamed(context, '/createQuest');
    setState(() {}); // refresh when coming back
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
              child: TabBarView(
                controller: _tabController,
                children: [
                  QuestList(status: null),
                  QuestList(status: QuestStatus.active),
                  QuestList(status: QuestStatus.completed),
                  QuestList(status: QuestStatus.failed),
                ],
              ),
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
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
