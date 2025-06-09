// ---------------- Quests Page ----------------

import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<Tab> _tabs = [
    Tab(text: 'All'),
    Tab(text: 'Available'),
    Tab(text: 'Claimed'),
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
    // TODO: handle creating quest
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.pinkAccent.shade100;
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
                        Icon(Icons.redeem_rounded,
                            size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 18),
                        Text(
                          'No Rewards',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            "You don't have any rewards. Create one to get started!",
                            style: textTheme.bodyMedium!
                                .copyWith(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          type: CustomButtonType.coloredIcon,
                          iconData: Icons.add_circle_outline_rounded,
                          title: 'Create Reward',
                          onPressed: _onCreateQuestPressed,
                          color: Colors.pinkAccent.shade100,
                          overlayColor: Colors.pink.shade100,
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
