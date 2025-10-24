import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';

/// Comprehensive examples page for FCTabBar showcasing all parameters.
class TabBarPage extends StatefulWidget {
  /// Creates a [TabBarPage].
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int _selectedTab = 0;
  final CNTabBarStyle _selectedStyle = CNTabBarStyle.standard;

  // Tab items for the tab bar
  final List<FCTabItem> _tabItems = const [
    FCTabItem(label: 'Home', icon: 'house.fill'),
    FCTabItem(label: 'Messages', icon: 'message.fill', badge: '3'),
    FCTabItem(label: 'Profile', icon: 'person.fill'),
    FCTabItem(
      label: 'Search',
      icon: 'magnifyingglass',
      role: FCTabItemRole.search,
    ),
  ];

  void _handleTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildSearchContent();
      case 2:
        return _buildMessagesContent();
      case 3:
        return _buildProfileContent();
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }

  Widget _buildHomeContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.house_fill,
            size: 64,
            color: CupertinoColors.systemBlue,
          ),
          SizedBox(height: 16),
          Text(
            'Home',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Welcome to the home tab'),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.search,
            size: 64,
            color: CupertinoColors.systemBlue,
          ),
          SizedBox(height: 16),
          Text(
            'Search',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Search for anything'),
        ],
      ),
    );
  }

  Widget _buildMessagesContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chat_bubble_fill,
            size: 64,
            color: CupertinoColors.systemBlue,
          ),
          SizedBox(height: 16),
          Text(
            'Messages',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('You have 3 new messages'),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.person_fill,
            size: 64,
            color: CupertinoColors.systemBlue,
          ),
          SizedBox(height: 16),
          Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('View your profile'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('FCTabBar Demo'),
      ),
      child: Column(
        children: [
          Expanded(child: _buildContent()),
          FCTabBar(
            items: _tabItems,
            selectedIndex: _selectedTab,
            onTabSelected: _handleTabSelected,
            style: _selectedStyle,
          ),
        ],
      ),
    );
  }
}
