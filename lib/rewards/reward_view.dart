// ---------------- Quests Page ----------------

import 'package:flutter/material.dart';
import 'package:task_game/data/model/reward_model.dart';
import 'package:task_game/shared/reward_list.dart';

class RewardsPage extends StatefulWidget {
  final int initialTabIndex;
  const RewardsPage({super.key, this.initialTabIndex = 0});

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

  void onCreateRewardPressed() {
    Navigator.pushNamed(context, '/createRewards');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.pinkAccent.shade100;

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
                  RewardList(status: null),
                  RewardList(status: RewardStatus.available),
                  RewardList(status: RewardStatus.claimed),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: onCreateRewardPressed,
            backgroundColor: primaryColor,
            elevation: 0,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
