// ---------------- Quests Page ----------------

import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';

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
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((tab) {
                  // Since no quests, same UI for all tabs
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list_alt_rounded,
                            size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 18),
                        Text(
                          'No Quests',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "You don't have any quests. Create one to get started!",
                            style: textTheme.bodyMedium!
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
                }).toList(),
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
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
