import 'package:dicoding_flutter_fundamental/notification/notification_service.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_page.dart';
import 'package:dicoding_flutter_fundamental/pages/favorite/favorite_page.dart';
import 'package:dicoding_flutter_fundamental/pages/home/home_page.dart';
import 'package:dicoding_flutter_fundamental/pages/setting/setting_page.dart';
import 'package:flutter/material.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  int _selectedIndex = 0;

  final NotificationService _notificationService = NotificationService();

  @override
  void dispose() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();

    super.dispose();
  }

  static const List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    SettingPage()
  ];

  @override
  void initState() {
    super.initState();

    _notificationService.configureSelectNotificationSubject(context, RestaurantDetailPage.routeName);
    _notificationService.configureDidReceiveLocalNotificationSubject(context, RestaurantDetailPage.routeName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Beranda"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorit"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting"
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
