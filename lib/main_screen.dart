import 'package:flutter/material.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/home/home_view.dart';
import 'package:task_game/profile/profile_view.dart';
import 'package:task_game/quests/quest_page_view.dart';
import 'package:task_game/rewards/reward_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();

  static final ValueNotifier<int> selectedTabNotifier = ValueNotifier<int>(0);
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = MainScreen.selectedTabNotifier.value;

  int questTabIndex = 0;

  @override
  void initState() {
    super.initState();
    MainScreen.selectedTabNotifier.addListener(() {
      setState(() {
        _selectedIndex = MainScreen.selectedTabNotifier.value;
      });
    });
  }

  void _onNavTapped(int index) {
    if (_selectedIndex != index) {
      // Reset quest tab index only if switching to another tab
      if (index != 1) questTabIndex = 0;
      MainScreen.selectedTabNotifier.value = index;
    }
  }

  static const List<String> _titles = [
    'Dashboard',
    'Quests',
    'Rewards',
    'Profile'
  ];

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        // Add UniqueKey to force rebuild even if same tab
        return QuestsPage(
          key: ValueKey(
              'quests_${questTabIndex}_${DateTime.now().millisecondsSinceEpoch}'),
          initialTabIndex: questTabIndex,
        );
      case 2:
        return const RewardsPage();
      case 3:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (_selectedIndex == 0)
          ? FloatingActionButton.small(onPressed: () {
              RewardDatabaseHelper.instance.shareRewardsDatabaseFile();
            })
          : null,
      appBar: AppBar(
        toolbarHeight: 70,
        shape: Border.all(color: Colors.grey.shade300),
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redeem_rounded),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
