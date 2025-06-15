// ---------------- Quests Page ----------------

import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/data/model/reward_model.dart';

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

  void onCreateRewardPressed() {
    Navigator.pushNamed(context, '/createRewards');
    setState(() {});
  }

  Future<List<Reward>> _fetchRewardsForTab(String tab) async {
    final db = RewardDatabaseHelper.instance;

    switch (tab) {
      case 'Available':
        return await db.fetchUnredeemedRewards();
      case 'Claimed':
        final all = await db.fetchAllRewards();
        return all.where((r) => r.status == RewardStatus.claimed).toList();
      case 'All':
      default:
        return await db.fetchAllRewards();
    }
  }

  String _statusLabel(RewardStatus status) =>
      status == RewardStatus.claimed ? 'Claimed' : 'Available';

  Color _statusColor(RewardStatus status) =>
      status == RewardStatus.claimed ? Colors.green : Colors.orange;

  @override
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.pinkAccent.shade100;
    final textTheme = Theme.of(context).textTheme;

    final List<IconData> icons = [
      Icons.card_giftcard, // Gift
      Icons.diamond, // Diamond
      Icons.coffee, // Coffee
      Icons.shopping_bag, // Bag
      Icons.tv, // TV
      Icons.restaurant, // Food
      Icons.flight, // Plane
    ];

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
                  return FutureBuilder<List<Reward>>(
                    future: _fetchRewardsForTab(tab.text!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final rewards = snapshot.data!;

                      if (rewards.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.redeem_rounded,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 18),
                              Text('No Rewards',
                                  style: textTheme.headlineSmall),
                              const SizedBox(height: 6),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
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
                                onPressed: onCreateRewardPressed,
                                color: primaryColor,
                                overlayColor: Colors.pink.shade100,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: rewards.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final reward = rewards[index];

                          // Fallback in case index is out of bounds
                          final icon = reward.iconIndex < icons.length
                              ? icons[reward.iconIndex]
                              : Icons.card_giftcard;

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Icon(icon, color: primaryColor),
                              title: Text(reward.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(reward.description),
                                  const SizedBox(height: 4),
                                  Text('Cost: ${reward.pointsCost} points'),
                                  Text(
                                    'Status: ${_statusLabel(reward.status)}',
                                    style: TextStyle(
                                      color: _statusColor(reward.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16),
                              onTap: () {
                                // Handle reward tap
                              },
                            ),
                          );
                        },
                      );
                    },
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
